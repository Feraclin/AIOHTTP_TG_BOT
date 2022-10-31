# from dataclasses import dataclass
from dataclasses import field

import marshmallow
from marshmallow import Schema
from marshmallow_dataclass import dataclass
from typing import Optional

from sqlalchemy import (
    Boolean,
    Column,
    ForeignKey,
    Integer,
    Text,
)
from sqlalchemy.orm import relationship, backref

from app.store.database.sqlalchemy_base import db


class BaseSchema(Schema):
    class Meta:
        unknown = marshmallow.EXCLUDE


@dataclass(base_schema=BaseSchema)
class Theme:
    id: Optional[int]
    title: str
    questions: Optional[list["Question"]] = None


@dataclass(base_schema=BaseSchema)
class Question:
    id: Optional[int]
    title: str
    theme_id: int
    answers: list["Answer"] = field(default_factory=list)


@dataclass(base_schema=BaseSchema)
class Answer:
    title: str
    is_correct: bool


class ThemeModel(db):
    __tablename__ = "themes"

    id = Column(Integer, primary_key=True)
    title = Column(Text, nullable=False, unique=True)
    questions = relationship('QuestionModel')

    def __repr__(self) -> str:
        return f'<ThemeModel({self.id=}. {self.title=})>'

    def to_dc(self) -> Theme:
        return Theme(id=self.id,
                     title=self.title,
                     # questions=[qu.to_dc() for qu in self.questions]
                     )


class QuestionModel(db):
    __tablename__ = "questions"

    id = Column(Integer, primary_key=True)
    title = Column(Text, nullable=False, unique=True)
    theme_id = Column(Integer, ForeignKey("themes.id", ondelete="CASCADE"), nullable=False)
    answers = relationship('AnswerModel')

    def __repr__(self) -> str:
        return f'<QuestionModel({self.id}, {self.title}, {self.theme_id}, {self.answers})>'

    def to_dc(self) -> Question:
        return Question(id=self.id,
                        title=self.title,
                        theme_id=self.theme_id,
                        answers=[an.to_dc() for an in self.answers])


class AnswerModel(db):
    __tablename__ = "answers"

    id = Column(Integer, primary_key=True)
    question_id = Column(Integer, ForeignKey('questions.id', ondelete="CASCADE"), nullable=False)
    title = Column(Text, nullable=False)
    is_correct = Column(Boolean, default=False)

    def __repr__(self) -> str:
        return f'<AnswerModel({self.title, self.is_correct})>'

    def to_dc(self) -> Answer:
        return Answer(self.title,
                      self.is_correct)
