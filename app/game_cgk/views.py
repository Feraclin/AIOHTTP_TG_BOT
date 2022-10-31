from aiohttp.web_exceptions import HTTPNotFound
from aiohttp_apispec import request_schema, response_schema, docs
from sqlalchemy import update
from sqlalchemy.exc import IntegrityError

from app.game_cgk.models import QuestionCGKModel
from app.game_cgk.schemas import QuestionCGKSchema, QuestionCGKAddAnswerSchema, QuestionCGKRemoveSchema, \
    ListQuestionSchema
from app.web.app import View
from app.web.mixins import AuthRequiredMixin
from app.web.schemes import OkResponseSchema
from app.web.utils import json_response


class QuestionCGKAddView(AuthRequiredMixin, View):
    @docs(tags=["CGK"], summary="Add Question", description="Add new Question")
    @request_schema(QuestionCGKSchema)
    @response_schema(QuestionCGKSchema)
    async def post(self):
        quest = await self.request.json()
        title = quest.get('title')

        try:
            question = await self.store.cgk.create_question(title=title,
                                                            description=quest.get('description'),
                                                            answer=quest.get('answer'))
            self.request.app.logger.info(f'Created new question: {title}')
        except IntegrityError as e:
            match e.orig.pgcode:
                case '23503':
                    raise HTTPNotFound()

        return json_response(data=QuestionCGKSchema().dump(question))


class QuestionCGKAddAnswerView(AuthRequiredMixin, View):
    @docs(tags=["CGK"], summary="Edit Question Answer", description="Edit Question Answer")
    @request_schema(QuestionCGKAddAnswerSchema)
    @response_schema(QuestionCGKAddAnswerSchema)
    async def post(self):
        self.request.app.logger.info(self.request.json())
        quest = await self.request.json()
        title = quest.get('title')
        answer = quest.get('answer')
        try:
            question = await self.store.cgk.update_question_answer(title=title,
                                                                   answer=answer)
            self.request.app.logger.info(f'Add new answer on question: {title}')
            if question:
                return json_response(data=QuestionCGKAddAnswerSchema().dump(question))
            else:
                raise HTTPNotFound()
        except IntegrityError as e:
            match e.orig.pgcode:
                case '23503':
                    raise HTTPNotFound()


class QuestionRemoveView(AuthRequiredMixin, View):
    @docs(tags=["CGK"], summary="Remove Question", description="Remove Question")
    @request_schema(QuestionCGKRemoveSchema)
    @response_schema(OkResponseSchema, 200)
    async def post(self):
        self.request.app.logger.info(self.request.json())
        quest = await self.request.json()
        title = quest.get('title')
        try:
            question = await self.store.cgk.remove_question(title=title,)
            self.request.app.logger.info(f'Remove question: {title}')
            if question:
                return json_response(data=QuestionCGKAddAnswerSchema().dump(question))
            else:
                raise HTTPNotFound()
        except IntegrityError as e:
            match e.orig.pgcode:
                case '23503':
                    raise HTTPNotFound()


class ListQuestionView(AuthRequiredMixin, View):
    @docs(tags=["CGK"], summary="All Question", description="All Question")
    @response_schema(ListQuestionSchema)
    async def get(self):
        try:
            questions = await self.store.cgk.list_questions()
            if questions:
                return json_response(data=ListQuestionSchema().dump({'questions': questions}))
            else:
                raise HTTPNotFound()
        except IntegrityError as e:
            match e.orig.pgcode:
                case '23503':
                    raise HTTPNotFound()

