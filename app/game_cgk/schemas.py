from marshmallow import Schema, fields
from marshmallow_sqlalchemy import SQLAlchemyAutoSchema, auto_field

from app.game_cgk.models import QuestionCGKModel


class BaseSQLAlchemy(SQLAlchemyAutoSchema):
    class Meta:
        load_instance = True
        include_relationships = True


class QuestionCGKSchema(BaseSQLAlchemy):
    class Meta:
        model = QuestionCGKModel


class QuestionCGKAddAnswerSchema(QuestionCGKSchema):

    description = auto_field(required=False,)


class QuestionCGKRemoveSchema(QuestionCGKSchema):

    answer = auto_field(required=False,)


class ListQuestionSchema(Schema):
    questions = fields.Nested(QuestionCGKSchema, many=True)
