from typing import Optional, TYPE_CHECKING

from sqlalchemy import text
from sqlalchemy.engine import URL
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncEngine, AsyncSession, create_async_engine
from sqlalchemy.orm import declarative_base, sessionmaker

from app.store.database import db


if TYPE_CHECKING:
    from app.web.app import Application


class Database:

    def __init__(self, app: "Application"):
        self.app = app
        self.DATABASE_URL = URL.create(drivername='postgresql+asyncpg',
                                       host=app.config.database.host,
                                       database=app.config.database.database,
                                       username=app.config.database.user,
                                       password=app.config.database.password,
                                       port=app.config.database.port)
        # self.DATABASE_URL = 'postgresql+asyncpg://kts_user:kts_pass@localhost/kts'
        self._engine: Optional[AsyncEngine] = None
        self._db: Optional[declarative_base] = None
        self.session: Optional[sessionmaker] = None

    async def connect(self, *_: list, **__: dict) -> None:
        self._db = db

        self._engine = create_async_engine(self.DATABASE_URL, echo=False, future=True)

        self.session = sessionmaker(bind=self._engine,
                                    expire_on_commit=False,
                                    autoflush=True,
                                    class_=AsyncSession)
        try:
            await self.app.store.admins.create_admin(self.app.config.admin.email,
                                                     self.app.config.admin.password)
        except IntegrityError:
            self.app.logger.info("Admin already exists")

    async def create_async_pull_query(self, query):
        async with self.session() as session:

            res = await session.execute(query)
            await session.commit()
        await self._engine.dispose()
        return res

    async def create_async_push_query(self, modification_variable):

        async with self.session.begin() as session:

            if type(modification_variable) is list:
                session.add_all(modification_variable)
            else:
                session.add(modification_variable)
            await session.commit()

        await self._engine.dispose()

    async def create_async_update_query(self, query):

        async with self.session.begin() as session:
            res = await session.execute(query)
            await session.commit()
            return res

    async def clear_db(self):
        async with self.session.begin() as session:
            for table in self._db.metadata.tables:
                await session.execute(text(f"TRUNCATE {table} CASCADE"))
                await session.execute(text(f"ALTER SEQUENCE {table} RESTART WITH 1"))

        await session.commit()

    async def disconnect(self, *_: list, **__: dict) -> None:
        try:
            await self._engine.dispose()
        except Exception as e:
            self.app.logger.info(f'Disconnect from engine error {e}')
