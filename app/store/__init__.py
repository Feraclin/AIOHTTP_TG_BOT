import typing

from app.store.database.database import Database
from app.store.rabbitMQ.rabbitMQ import RabbitMQ

if typing.TYPE_CHECKING:
    from app.web.app import Application


class Store:
    def __init__(self, app: "Application"):
        from app.store.admin.accessor import AdminAccessor
        from app.store.cgk.accessor import CGKAccessor
        from app.store.bot_tg.bot_tg import BotAccessor

        self.admins = AdminAccessor(app)
        self.cgk = CGKAccessor(app)
        self.tg_bot = BotAccessor(token=app.config.bot.token_tg, n=2, app=app)


def setup_store(app: "Application"):
    app.rabbitMQ = RabbitMQ(app)
    app.database = Database(app)
    app.on_startup.append(app.database.connect)
    app.on_startup.append(app.rabbitMQ.connect)
    app.on_cleanup.append(app.database.disconnect)
    app.on_cleanup.append(app.rabbitMQ.disconnect)
    app.store = Store(app)
