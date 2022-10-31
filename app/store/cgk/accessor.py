from datetime import datetime
from random import choices
from typing import List, Tuple

from sqlalchemy import select, update, delete
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import selectinload

from app.base.base_accessor import BaseAccessor
from app.game_cgk.models import QuestionCGKModel, GameSessionModel, UserModel, TeamModel, \
    GameSessionQuestionModel
from app.store.cgk.dataclasses import QuestionCGK, User, GameSession
from app.store.bot_tg.constant import NUM_OF_QUESTION


class CGKAccessor(BaseAccessor):
    async def create_question(self,
                              title: str,
                              description: str,
                              answer: list[str]
                              ) -> QuestionCGK:
        question_query = QuestionCGKModel(title=title,
                                          answer=answer,
                                          description=description)

        await self.app.database.create_async_push_query(question_query)

        return question_query.to_dc()

    async def update_question_answer(self, title: str, answer: list[str]) -> QuestionCGK:

        question_update = update(QuestionCGKModel).where(QuestionCGKModel.title==title)\
            .values(answer=QuestionCGKModel.answer + answer).returning(QuestionCGKModel)
        question = await self.app.database.create_async_update_query(question_update)
        return QuestionCGK(*(question.fetchone())) if question else None

    async def remove_question(self, title: str) -> QuestionCGK:
        question_delete = delete(QuestionCGKModel).where(QuestionCGKModel.title==title)\
            .returning(QuestionCGKModel)
        question = await self.app.database.create_async_update_query(question_delete)
        return QuestionCGK(*(question.fetchone())) if question else None

    async def list_questions(self) -> List[QuestionCGK]:
        question_query = select(QuestionCGKModel)

        res = await self.app.database.create_async_pull_query(question_query)

        return [row.to_dc() for row in res.scalars().fetchall()]

    async def list_questions_to_game(self) -> List[QuestionCGK]:

        question_query = select(QuestionCGKModel)

        res = (await self.app.database.create_async_pull_query(question_query)).scalars().fetchall()
        self.app.logger.info('Question for game')
        res_choice = choices(res, k=NUM_OF_QUESTION)
        return [row.to_dc() for row in res_choice]

    async def question_by_id(self, question_id):
        question_query = select(QuestionCGKModel).where(QuestionCGKModel.id == question_id)

        res = await self.app.database.create_async_pull_query(question_query)

        return res.scalars().first().to_dc()

    async def get_next_question_from_session_id(self, session_id,
                                                status: str = None,
                                                new_status: str | None = 'asked') -> Tuple[QuestionCGK, str] | bool:
        question_query = select(GameSessionQuestionModel).where(GameSessionQuestionModel.game_session_id == session_id,
                                                                GameSessionQuestionModel.status == status)\
            .options(selectinload(GameSessionQuestionModel.question)).limit(1)

        res = await self.app.database.create_async_pull_query(question_query)

        question_model = res.scalars().first()
        print(question_model)

        if not question_model:
            await self.app.store.tg_bot.cgk.add_question_to_session(session_id)
            await self.get_next_question_from_session_id(session_id=session_id,
                                                         status=None,
                                                         new_status=None)

        question_query = update(GameSessionQuestionModel).where(GameSessionQuestionModel.id == question_model.id)\
            .values(status=new_status)

        await self.app.database.create_async_update_query(question_query)

        question = await self.question_by_id(question_model.question_id)

        return question, question_model.player_answer

    async def create_game_session(self,
                                  chat_id: int,
                                  status: str,
                                  capitan: User
                                  ) -> GameSession:

        session_query = GameSessionModel(chat_id=chat_id,
                                         status=status,
                                         capitan_id=capitan.user_id,
                                         start_date=datetime.now()
                                         )

        await self.app.database.create_async_push_query(session_query)

        return session_query.to_dc()

    async def list_active_sessions(self) -> List[GameSession]:
        session_query = select(GameSessionModel).where(GameSessionModel.status != 'complete')

        res = await self.app.database.create_async_pull_query(session_query)

        return [row.to_dc() for row in res.scalars().fetchall()]

    async def check_active_session_from_chat_id(self, chat_id):
        session_query = select(GameSessionModel).where(GameSessionModel.chat_id == chat_id, GameSessionModel.status != 'complete')

        res = (await self.app.database.create_async_pull_query(session_query)).scalars().first()

        return True if res is not None else False

    async def get_session_by_chat_id_and_status(self, chat_id, status: str):
        session_query = select(GameSessionModel).where(GameSessionModel.chat_id == chat_id, GameSessionModel.status == status)

        res = (await self.app.database.create_async_pull_query(session_query)).scalars().first()

        return res

    async def create_user(self,
                          user_id: int,
                          nick: str) -> User:
        user_query = UserModel(id=user_id,
                               nick=nick)
        try:
            await self.app.database.create_async_push_query(user_query)
        except IntegrityError as e:
            match e.orig.pgcode:
                case '23503':
                    print('User already exists')

        return user_query.to_dc()

    async def get_user_from_id(self, user_id: int) -> User:
        user_query = select(UserModel).where(UserModel.id == user_id)

        res = await self.app.database.create_async_pull_query(user_query)

        return res.scalars().first().to_dc()

    async def create_team(self, session_id, user_id):
        team_query = TeamModel(session_id=session_id, user_id=user_id)

        await self.app.database.create_async_push_query(team_query)

        return team_query.to_dc()

    async def get_team_by_session_id(self, session_id):
        team_query = select(TeamModel).where(TeamModel.session_id == session_id)

        res = await self.app.database.create_async_pull_query(team_query)

        return [row.to_dc() for row in res.scalars().fetchall()]