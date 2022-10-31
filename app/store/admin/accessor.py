from hashlib import sha256
from sqlalchemy import select
from app.admin.models import Admin, AdminModel
from app.base.base_accessor import BaseAccessor


class AdminAccessor(BaseAccessor):
    async def get_by_email(self, email: str) -> Admin | None:
        query = select(AdminModel).where(AdminModel.email == email)

        res = (await self.app.database.create_async_pull_query(query)).scalars().first()

        if not res:
            return None

        return res.to_dc()

    async def create_admin(self, email: str, password: str) -> Admin:
        admin = AdminModel(email=email,
                           password=sha256(password.encode()).hexdigest())

        await self.app.database.create_async_push_query(admin)

        return admin.to_dc()
