from marshmallow import Schema, fields
from marshmallow_sqlalchemy import SQLAlchemyAutoSchema, auto_field

from app.admin.models import AdminModel


class AdminSchema(Schema):
    id = fields.Int(required=False)
    email = fields.Email(required=True)
    password = fields.Str(required=True, load_only=True)


class AdminResponseScheme(Schema):
    id = fields.Int(required=True)
    email = fields.Email(required=True)


class BaseSQLAlchemy(SQLAlchemyAutoSchema):
    class Meta:
        load_instance = True
        include_relationships = True


class AdminModelSchema(BaseSQLAlchemy):
    class Meta:
        model = AdminModel

    email = auto_field(required=True)
    password = auto_field(load_only=True)
