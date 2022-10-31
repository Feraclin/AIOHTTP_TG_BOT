import asyncio
import datetime
from asyncio import Task
from random import choice
from typing import Optional, TYPE_CHECKING

from sqlalchemy import update, select
from sqlalchemy.exc import IntegrityError

from app.game_cgk.models import GameSessionModel, GameSessionQuestionModel
from app.store.bot_tg.constant import check_time, TIME_TO_ACTIVE, TIME_TO_ASKED, TIME_TO_ANSWERED, TIME_TO_CHECKING, \
    TIME_TO_CHECKED, WIN_POINT, TIME_TO_RESPONSE, TIME_TO_GRAB
from app.store.cgk.dataclasses import GameSession
from app.store.tg_api.accessor import TgClient

if TYPE_CHECKING:
    from app.web.app import Application


class CGK:

    def __init__(self, token: str, app: 'Application'):
        self.app = app
        self.tg_client = TgClient(token)
        self._task: Optional[Task] = None

    async def _worker(self):
        while self.app.store.tg_bot.is_game:

            active_game = await self.app.store.cgk.list_active_sessions()
            if not active_game:
                self.app.store.tg_bot.is_game = False
                self.app.logger.info(f'game stopped in {datetime.datetime.now()}')
            try:
                for session in active_game:
                    match session.status:
                        case 'start':
                            await self.add_time_to_session(session)
                            await self.new_game(session)
                        case 'active' if check_time(session.start_date, TIME_TO_ACTIVE):
                            await self.add_time_to_session(session)
                            await self.wait_teams(session)
                        case 'asked' if check_time(session.start_date, TIME_TO_ASKED):
                            await self.add_time_to_session(session)
                            await self.ask_question(session)
                        case 'response' if check_time(session.start_date, TIME_TO_RESPONSE):
                            await self.add_time_to_session(session)
                            await self.pick_respondent(session)
                        case 'grab' if check_time(session.start_date, TIME_TO_GRAB):
                            await self.add_time_to_session(session)
                            await self.grab_question(session)
                        case 'answered' if check_time(session.start_date, TIME_TO_ANSWERED):
                            await self.add_time_to_session(session)
                            await self.check_answer(session)
                        case 'checking' if check_time(session.start_date, TIME_TO_CHECKING):
                            await self.add_time_to_session(session)
                            await self.check_score(session)
                        case 'checked' if check_time(session.start_date, TIME_TO_CHECKED):
                            await self.add_time_to_session(session)
                            await self.end_game(session)
                await asyncio.sleep(1)
            finally:
                continue

    async def start(self):
        self._task = asyncio.create_task(self._worker())

    async def stop(self):
        self._task.cancel()

    async def change_status_session(self, session, status) -> None:
        query = update(GameSessionModel).where(GameSessionModel.id == session.session_id).values(status=status,
                                                                                                 start_date=datetime.datetime.now())
        await self.app.database.create_async_update_query(query)

        self.app.logger.info(f'Session {session.session_id} changed to {status}')

    async def add_time_to_session(self, session, time: int = 5) -> None:
        query = update(GameSessionModel).where(GameSessionModel.id == session.session_id) \
            .values(start_date=GameSessionModel.start_date + datetime.timedelta(seconds=time))

        await self.app.database.create_async_update_query(query)

        self.app.logger.info(f'Session {session.session_id} add 5 seconds')

    async def new_game(self, session):
        self.app.logger.info(f'started {session}')
        chat_id = session.chat_id

        keyboard = {'inline_keyboard': [
            [{"text": "Yes", 'callback_data': '/yes'},
             {"text": "No", 'callback_data': '/no'}]
        ],
            "resize_keyboard": True,
            "one_time_keyboard": True
        }
        await self.tg_client.send_keyboard(
            text='Кто готов?',
            chat_id=chat_id,
            keyboard=keyboard
        )
        await self.add_question_to_session(session)
        await self.change_status_session(session, 'active')

    async def wait_teams(self, session):
        self.app.logger.info(f'active {session}')

        try:
            users = await self.app.store.cgk.get_team_by_session_id(session_id=session.session_id)

            users_id = [row.user for row in users]
            capitan = choice(users_id)
            admin_query = update(GameSessionModel).where(GameSessionModel.id == session.session_id).values(capitan_id=capitan)
            capitan_nick = await self.app.store.cgk.get_user_from_id(capitan)
            await self.app.database.create_async_update_query(admin_query)
            team = [(await self.app.store.cgk.get_user_from_id(i)).nick for i in set(users_id)]

            await self.tg_client.send_message(chat_id=session.chat_id, text=f'Сегодня играют {", ".join(team)}')
            await self.tg_client.send_message(chat_id=session.chat_id, text=f'Наш капитан {capitan_nick.nick}')

            await self.change_status_session(session, 'asked')
        except IntegrityError as e:
            self.app.logger.info(f'Create team failed {e}')

    async def add_question_to_session(self, session):
        question_list = await self.app.store.cgk.list_questions_to_game()

        question_query = [GameSessionQuestionModel(question_id=i.question_id,
                                                   game_session_id=session.session_id,
                                                   ) for i in question_list]
        self.app.logger.info(f'Question add for game {question_query}')
        try:
            await self.app.database.create_async_push_query(question_query)
        except IntegrityError as e:
            self.app.logger.info(f'add question  {e}')

    async def ask_question(self, session):
        self.app.logger.info(f'Response {session}')

        try:
            question = (await self.app.store.cgk.get_next_question_from_session_id(session.session_id))[0]
            await self.tg_client.send_message(chat_id=session.chat_id, text=question.title)
            await self.tg_client.send_message(chat_id=session.chat_id,
                                              text=f'Время на ответ {TIME_TO_RESPONSE}. Досрочные ответы не принимаются')
            await self.change_status_session(session, 'response')
        except IntegrityError as e:
            self.app.logger.info(f'pick question {e}')

    async def pick_respondent(self, session):
        self.app.logger.info(f'answered {session}')

        try:
            users = await self.app.store.cgk.get_team_by_session_id(session_id=session.session_id)

            users_id = [row.user for row in users]

            keyboard = {'inline_keyboard': [
                    *[[{"text": (await self.app.store.cgk.get_user_from_id(i)).nick, 'callback_data': i}] for i in set(users_id)]
                ],
                "resize_keyboard": True,
                "one_time_keyboard": True,
                'selective': True,
            }
            await self.tg_client.send_keyboard(
                chat_id=session.chat_id,
                text=f'Кто будет отвечать?',
                keyboard=keyboard
            )
            await self.change_status_session(session, 'grab')
        except IntegrityError as e:
            self.app.logger.info(f'Pick respondent {e}')

    async def grab_question(self, session):
        self.app.logger.info(f'answered {session}')

        try:
            respondent_query = select(GameSessionQuestionModel.respondent) \
                .where(GameSessionQuestionModel.game_session_id == session.session_id,
                       GameSessionQuestionModel.status == 'asked')
            respondent = (await self.app.database.create_async_pull_query(respondent_query)).scalar()
            respondent_name = f'Отвечает товарищ {(await self.app.store.cgk.get_user_from_id(respondent)).nick}'\
                if respondent else 'Отвечающий не был выбран'
            await self.tg_client.send_message(chat_id=session.chat_id,
                                              text=respondent_name)
            await self.change_status_session(session, 'answered')
        except IntegrityError as e:
            self.app.logger.info(f'Grab question failed {e}')

    async def check_answer(self, session):
        self.app.logger.info(f'checking {session}')

        try:
            question = await self.app.store.cgk.get_next_question_from_session_id(session_id=session.session_id,
                                                                                  status='asked',
                                                                                  new_status='complete')
            if not question:
                await self.tg_client.send_message(chat_id=session.chat_id, text=f'Вопросы кончились добавим еще')
                await self.add_question_to_session(session=session.session_id)
                await self.change_status_session(session, 'asked')
                return
            await self.tg_client.send_message(chat_id=session.chat_id, text=f'Ваш ответ {question[1]}.')
            await asyncio.sleep(1 / 2)
            await self.tg_client.send_message(chat_id=session.chat_id,
                                              text=f'Верный ответ {question[0].answer[0].capitalize()}, {question[0].description.capitalize()}')
            if question[1] in question[0].answer:
                query = update(GameSessionModel).where(GameSessionModel.id == session.session_id) \
                    .values(team_point=GameSessionModel.team_point + 1)
            else:
                query = update(GameSessionModel).where(GameSessionModel.id == session.session_id) \
                    .values(bot_point=GameSessionModel.bot_point + 1)
            await self.app.database.create_async_update_query(query)
            await self.change_status_session(session, 'checking')
        except IntegrityError as e:
            self.app.logger.info(f'Check Answer {e}')

    async def check_score(self, session):
        try:
            res = await self.result(session.session_id)

            await self.tg_client.send_message(chat_id=session.chat_id,
                                              text=f'Счет становится Знатоки - {res.team_point}:{res.bot_point} - Бот')

            if max(res.bot_point, res.team_point) >= WIN_POINT:
                win_text = ('Я проиграл', 'Я победил')[res.bot_point > res.team_point]
                await self.tg_client.send_message(chat_id=session.chat_id,
                                                  text=win_text)
                await self.end_game(session)
            else:
                await self.change_status_session(session, 'asked')
        except IntegrityError as e:
            self.app.logger.info(f'Check score {e}')

    async def result(self, session_id: int) -> GameSession:
        query = select(GameSessionModel).where(GameSessionModel.id == session_id)

        res = (await self.app.database.create_async_pull_query(query)).scalars().first().to_dc()
        return res


    async def end_game(self, session):
        self.app.logger.info(f'complete {session}')
        await self.change_status_session(session, 'complete')
