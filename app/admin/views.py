from aiohttp.web import HTTPForbidden
from aiohttp.web_exceptions import HTTPUnauthorized
from aiohttp_apispec import request_schema, response_schema, docs
from aiohttp_session import new_session

from app.admin.schemes import AdminSchema, AdminModelSchema
from app.web.app import View
from app.web.mixins import AuthRequiredMixin
from app.web.utils import json_response


class AdminLoginView(View):
    @docs(tags=["admin"], summary="Login Admin", description="Logged as admin")
    @request_schema(AdminModelSchema)
    @response_schema(AdminModelSchema, 200)
    async def post(self):
        email, password = self.data["email"], self.data["password"]
        # проверка наличия администратора с данным паролем и его валидность
        self.request.app.logger.info(email, password)

        if not (admin := await self.request.app.store.admins.get_by_email(email)) or \
                admin.check_password(password):

            raise HTTPForbidden

        self.request.app.logger.info(admin)

        admin_data = AdminSchema().dump(admin)
        session = await new_session(request=self.request)
        session["admin"] = admin_data

        self.request.app.logger.info("admin login successful")

        return json_response(data=admin_data)


class AdminCurrentView(AuthRequiredMixin, View):
    @docs(tags=["admin"], summary="Current Admin", description="ID and email of current admin")
    @response_schema(AdminSchema, 200)
    async def get(self):

        if self.request.admin:
            self.request.app.logger.info("check current admin successful")
            return json_response(data=AdminModelSchema().dump(self.request.admin))
        else:
            raise HTTPUnauthorized()
