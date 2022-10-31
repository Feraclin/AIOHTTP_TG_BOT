from sqlalchemy import (
    Column,
    ForeignKey,
    Integer,
    Text, VARCHAR, ARRAY, TIMESTAMP, BigInteger
)
from sqlalchemy.orm import relationship

from app.store.cgk.dataclasses import QuestionCGK, User, GameSession, TeamPlayer, GameSessionQuestion
from app.store.database.sqlalchemy_base import db


class UserModel(db):
    # noinspection SpellCheckingInspection
    __tablename__ = 'users'

    id = Column(BigInteger, primary_key=True)
    nick = Column(VARCHAR(32), nullable=False)

    def __repr__(self) -> str:
        return f'{self.nick}'

    def to_dc(self) -> User:
        return User(user_id=self.id,
                    nick=self.nick)


class GameSessionModel(db):
    __tablename__ = 'game_session'

    id = Column(Integer, primary_key=True)
    chat_id = Column(BigInteger, nullable=False)
    capitan_id = Column(BigInteger, ForeignKey('users.id'), nullable=True, default=None)
    status = Column(VARCHAR(32), nullable=True)
    start_date = Column(TIMESTAMP, nullable=False)
    bot_point = Column(Integer, default=0)
    team_point = Column(Integer, default=0)
    capitan = relationship(UserModel, backref='users', lazy='subquery')

    def __repr__(self):
        return f'{self.chat_id}: {self.status}'

    def to_dc(self) -> GameSession:
        return GameSession(
            session_id=self.id,
            chat_id=self.chat_id,
            capitan=self.capitan_id,
            status=self.status,
            start_date=self.start_date,
            bot_point=self.bot_point,
            team_point=self.team_point
        )


class QuestionCGKModel(db):
    __tablename__ = 'question_cgk'

    id = Column(Integer, primary_key=True)
    title = Column(Text, nullable=False, unique=True)
    answer = Column(ARRAY(VARCHAR(32)), nullable=False)
    description = Column(Text, nullable=False)

    def __repr__(self) -> str:
        return f'{self.title}\n{self.answer}\n{self.description}'

    def to_dc(self) -> QuestionCGK:
        return QuestionCGK(title=self.title,
                           answer=self.answer,
                           description=self.description,
                           question_id=self.id)


class GameSessionQuestionModel(db):
    __tablename__ = 'game_session_question'

    id = Column(Integer, primary_key=True)
    question_id = Column(Integer, ForeignKey('question_cgk.id', ondelete='CASCADE'), nullable=False)
    game_session_id = Column(Integer, ForeignKey('game_session.id', ondelete='CASCADE'), nullable=False)
    status = Column(VARCHAR(32), nullable=True)
    player_answer = Column(VARCHAR(32), nullable=True)
    respondent = Column(BigInteger, ForeignKey('users.id'), nullable=True, default=None)
    question = relationship(QuestionCGKModel, backref='question_cgk')
    session = relationship(GameSessionModel, backref='game_session_cgk')
    respondent_user = relationship(UserModel, backref='respondent_user')

    def __repr__(self):
        return f'{self.question_id}: {self.status}, отвечает{self.respondent}'

    def to_dc(self) -> GameSessionQuestion:
        return GameSessionQuestion(
                                    session=self.session.to_dc(),
                                    question=self.question.to_dc(),
                                    response=self.user,
                                    status=self.status
                                    )


class TeamModel(db):

    __tablename__ = 'team_models'
    id = Column(Integer, primary_key=True)
    session_id = Column(Integer, ForeignKey('game_session.id', ondelete='CASCADE'), nullable=False)
    user_id = Column(BigInteger, ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    user = relationship(UserModel, backref='user', lazy='subquery')
    session = relationship(GameSessionModel, backref='game_session', lazy='immediate')

    def __repr__(self):
        return f'{self.session_id}: {self.user_id}'

    def to_dc(self) -> TeamPlayer:
        return TeamPlayer(session=self.session_id, user=self.user_id)
