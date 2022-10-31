from datetime import datetime
from typing import List, ClassVar, Type

import marshmallow
from marshmallow import Schema
from marshmallow_dataclass import dataclass


class BaseSchema(Schema):
    class Meta:
        unknown = marshmallow.EXCLUDE


@dataclass(base_schema=BaseSchema)
class QuestionCGK:
    question_id: int
    title: str
    answer: List[str]
    description: str | None


@dataclass(base_schema=BaseSchema)
class User:
    user_id: int
    nick: str

    Schema: ClassVar[Type[Schema]] = Schema


@dataclass(base_schema=BaseSchema)
class GameSession:
    session_id: int
    chat_id: int
    capitan: User | int
    status: str | None
    start_date: datetime | None
    bot_point: int
    team_point: int

    Schema: ClassVar[Type[Schema]] = Schema


@dataclass(base_schema=BaseSchema)
class GameQuestion:
    session: GameSession
    question: QuestionCGK
    status: str
    responsible_id: User | None = None

    Schema: ClassVar[Type[Schema]] = Schema


@dataclass(base_schema=BaseSchema)
class TeamPlayer:
    session: int
    user: int

    Schema: ClassVar[Type[Schema]] = Schema


@dataclass(base_schema=BaseSchema)
class Team:
    session: GameSession
    user_list: List[TeamPlayer]

    Schema: ClassVar[Type[Schema]] = Schema


@dataclass(base_schema=BaseSchema)
class GameSessionQuestion:
    session: GameSession
    question: QuestionCGK
    response: User | None
    status: str

    Schema: ClassVar[Type[Schema]] = Schema
