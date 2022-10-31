from dataclasses import dataclass
from hashlib import sha256
from typing import Optional

from aiohttp_session import Session
from sqlalchemy import Column, Integer, VARCHAR

from app.store.database.sqlalchemy_base import db


@dataclass
class Admin:
    id: int
    email: str
    password: Optional[str] = None

    def check_password(self, password) -> bool:
        return self.password != sha256(password.encode("utf-8")).hexdigest()

    @classmethod
    def from_session(cls, session: Optional[Session]) -> Optional["Admin"]:
        return cls(id=session["admin"]["id"], email=session["admin"]["email"])


class AdminModel(db):
    __tablename__ = "admins"

    id = Column(Integer, primary_key=True)
    email = Column(VARCHAR(255), nullable=False, unique=True)
    password = Column(VARCHAR(255), nullable=False)

    def to_dc(self):
        return Admin(id=self.id,
                     email=self.email,
                     password=self.password)
