# Структура бота из статьи https://habr.com/ru/company/kts/blog/598575/

import asyncio
import datetime
from typing import List, TYPE_CHECKING

import aio_pika
import bson
from sqlalchemy import update, select
from sqlalchemy.exc import IntegrityError

from app.game_cgk.models import GameSessionQuestionModel, GameSessionModel
from app.store.cgk.dataclasses import User, GameSession
from app.store.bot_tg.constant import check_time, TIME_TO_TG_SERVER
from app.store.tg_api.accessor import TgClient
from app.store.tg_api.schemes import UpdateObj

if TYPE_CHECKING:
    from app.web.app import Application


class Worker:
    def __init__(self, token: str, concurrent_workers: int, app: 'Application'):
        self.tg_client = TgClient(token)
        self.app = app
        self.concurrent_workers = concurrent_workers
        self._tasks: List[asyncio.Task] = []
        self.game: int | None = None
        self.team: List[User] = []
        self._is_game = False
        self.pre_round = False

    async def handle_update(self, upd: UpdateObj):
        self.app.logger.info(f"worker text: {upd.message.text}" if upd.message else f'worker text: {upd.callback_query.message.text}')
        if upd.message:
            try:
                active_game = await self.app.store.cgk.list_active_sessions()
                if active_game and not self.app.store.tg_bot.is_game:
                    self.app.store.tg_bot.is_game = True
                    await self.app.store.tg_bot.cgk.start()
                match upd.message.text:
                    case '/start':
                        await self.create_session(upd)
                    case '/stop':
                        await self.stop_game(upd)
                    case '/ping':
                        await self.tg_client.send_message(
                                                            upd.message.chat.id,
                                                            text=f'{upd.message.from_.username} /pong')
                    case _ if active_game:
                        active_sessions_chat_id = {session.chat_id: session.session_id for session in active_game if
                                                   session.status == 'answered'}
                        self.app.logger.info(f'Сессии ждут ответа{active_sessions_chat_id}')
                        if upd.message.chat.id in active_sessions_chat_id.keys():
                            await self.add_answer_from_respondent(upd, active_sessions_chat_id[upd.message.chat.id])
            except IntegrityError as e:
                self.app.logger.info(f'start {e}')
        elif upd.callback_query:
            try:
                active_game = await self.app.store.cgk.list_active_sessions()
                active_sessions_chat_id = {session.chat_id: session.session_id for session in active_game if
                                           session.status == 'grab'}
                match upd.callback_query.data:
                    case '/yes':
                        await self.add_to_team(upd)
                    case _ if upd.callback_query.message.chat.id in active_sessions_chat_id.keys():
                        await self.add_respondent(upd, active_sessions_chat_id[upd.callback_query.message.chat.id])
            except IntegrityError as e:
                self.app.logger.info(f'callback {e}')

    async def _worker_rabbit(self):
        try:
            channel = await self.app.rabbitMQ.connection_.channel()
            await channel.set_qos(prefetch_count=100)

            auth_exchange = await channel.declare_exchange(name="auth",
                                                           type=aio_pika.ExchangeType.TOPIC,
                                                           durable=True)

            queue = await channel.declare_queue(name=f"tg_bot",
                                                durable=True,)
            await queue.bind(auth_exchange, routing_key="tg_bot")

            await queue.consume(self.on_message, no_ack=True)

            print(" [*]worker.rabbit Waiting for messages")
            await asyncio.Future()
        except asyncio.CancelledError as e:
            self.app.logger.info(f'rabbit_worker asyncio {e}')
        except Exception as e:
            self.app.logger.info(f'rabbit_worker {e}')

    async def on_message(self, message):
        upd = UpdateObj.Schema().load(bson.loads(message.body))
        print("worker.rabbit is: %r" % upd)
        await self.handle_update(upd)

    async def start(self):
        self._tasks = [asyncio.create_task(self._worker_rabbit()) for _ in range(5)]

    async def stop(self):
        for t in self._tasks:
            t.cancel()

    async def create_session(self, upd) -> None:

        if await self.app.store.cgk.check_active_session_from_chat_id(upd.message.chat.id):
            self.app.logger.info(f"Session in {upd.message.chat.id} already exists")
            await self.tg_client.send_message(
                upd.message.chat.id,
                text='Игра уже в процессе')
            return

        self.app.logger.info("Creating session")
        time_msg = datetime.datetime.utcfromtimestamp(upd.message.date)

        self.app.logger.info((datetime.datetime.now() - time_msg) / datetime.timedelta(seconds=1))

        if not check_time(time_msg, TIME_TO_TG_SERVER):
            try:
                user = await self.app.store.cgk.create_user(user_id=upd.message.from_.id,
                                                            nick=upd.message.from_.username)
                session = await self.app.store.cgk.create_game_session(chat_id=upd.message.chat.id,
                                                                       status='start',
                                                                       capitan=user)

                await self.app.store.cgk.create_team(session_id=session.session_id, user_id=upd.message.from_.id)

                if not self.app.store.tg_bot.is_game:
                    self.app.store.tg_bot.is_game = True
                    await self.app.store.tg_bot.cgk.start()

            except IntegrityError as e:
                self.app.logger.info(f'Ошибка создания сессии {e}')

        else:
            await self.tg_client.send_message(
                upd.message.chat.id,
                text='Не буду с тобой играть')

    async def add_to_team(self, upd) -> None:
        try:
            session = await self.app.store.cgk.get_session_by_chat_id_and_status(chat_id=upd.callback_query.message.chat.id,
                                                                                 status='active')
            if session is not None:
                await self.app.store.cgk.create_user(user_id=upd.callback_query.from_.id,
                                                     nick=upd.callback_query.from_.username)
                await self.app.store.cgk.create_team(session_id=session.id, user_id=upd.callback_query.from_.id)
            else:
                await self.tg_client.send_message(
                    upd.callback_query.message.chat.id,
                    text='Игра еще не создана или уже в процессе')
        except IntegrityError as e:
            self.app.logger.info(f'Add to team failed {e}')

    async def add_respondent(self, upd, session_id) -> None:
        try:
            check_query = select(GameSessionModel.capitan_id).where(GameSessionModel.id == session_id)
            capitan = (await self.app.database.create_async_pull_query(check_query)).scalars().first()
            print(f'Капитан {capitan}')
            print(upd.callback_query.from_.id)
            if upd.callback_query.from_.id == capitan:
                question_query = update(GameSessionQuestionModel)\
                    .where(GameSessionQuestionModel.game_session_id == session_id,
                           GameSessionQuestionModel.status == 'asked')\
                    .values(respondent=int(upd.callback_query.data))
                await self.app.database.create_async_update_query(question_query)
        except IntegrityError as e:
            self.app.logger.info(f'Add respondent failed {e}')

    async def add_answer_from_respondent(self, upd, session_id):
        self.app.logger.info(f'считали ответ: {upd.message.text}')
        try:
            question_query = update(GameSessionQuestionModel)\
                .where(GameSessionQuestionModel.game_session_id == session_id,
                       GameSessionQuestionModel.status == 'asked',
                       GameSessionQuestionModel.respondent == upd.message.from_.id)\
                .values(player_answer=upd.message.text.lower())
            await self.app.database.create_async_update_query(question_query)
        except IntegrityError as e:
            self.app.logger.info(f'Add respondent failed {e}')

    async def stop_game(self, upd) -> None:
        try:
            question_query = update(GameSessionModel)\
                .where(GameSessionModel.chat_id == upd.message.chat.id,
                       GameSessionModel.status != 'complete')\
                .values(status='complete').returning(GameSessionModel)
            res = GameSession(*(await self.app.database.create_async_update_query(question_query)).fetchone())
            await self.tg_client.send_message(
                upd.message.chat.id,
                text='Игра прекращена досрочно')
            await self.tg_client.send_message(chat_id=upd.message.chat.id,
                                              text=f'Счет Знатоки - {res.team_point}:{res.bot_point} - Бот')
        except IntegrityError as e:
            self.app.logger.info(f'Stop game failed {e}')
