import asyncio
from datetime import datetime
from hashlib import sha256
from pprint import pprint

from sqlalchemy import select, update, insert
from sqlalchemy.engine import ChunkedIteratorResult
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker, selectinload

from app.admin.models import AdminModel
from app.game_cgk.models import GameSessionModel, QuestionCGKModel, GameSessionQuestionModel, TeamModel
from app.store.cgk.dataclasses import QuestionCGK
from tests.fixtures.models import ThemeModel, QuestionModel, AnswerModel, Answer
from app.store.bot_tg.constant import NUM_OF_QUESTION

# from app.quiz_store.sqlalchemy_schemes import QuestionModelSchema

DATABASE_URL = 'postgresql+asyncpg://feraclin:12wm16ln@127.0.0.1:5433/kts_st'

# ADMIN
I1I = select(AdminModel).where(AdminModel.email == "admin@admin.com")
I1 = insert(AdminModel).values(email="admin@admin.com",
                               password=sha256('admin'.encode()).hexdigest()) \
    .returning(AdminModel.id)

# THEME
I2I = select(ThemeModel.id, ThemeModel.title).where(ThemeModel.title == 'web1')

I3I = select(ThemeModel.id, ThemeModel.title)

# QUESTION
I4I = select(QuestionModel.id, QuestionModel.title, QuestionModel.theme_id).where(
    QuestionModel.theme_id == 1)
I4 = insert(QuestionModel).values(title='QuestionModel5', theme_id=1).returning(QuestionModel.id)

# ANSWERS
answers = [Answer(title='Question1', is_correct=True),
           Answer(title='Question1', is_correct=False)]
answer_lst = [{'question_id': 1, 'title': answer.title, 'is_correct': answer.is_correct} for answer
              in answers]
I5I = select(AnswerModel.title, AnswerModel.is_correct).where(AnswerModel.question_id == 1)
I5 = insert(AnswerModel).values(answer_lst)

# QUESTIONS and ANSWERS
# I6I = ('''SELECT q.theme_id, q.title, a.title, a.is_correct
# FROM questions q JOIN answers a ON q.id = a.question_id
# WHERE q.theme_id = 1''')

I7I = select(QuestionModel.theme_id,
             QuestionModel.title,
             AnswerModel.title,
             AnswerModel.is_correct).join(AnswerModel,
                                          QuestionModel.id == AnswerModel.question_id)\
    .where(QuestionModel.theme_id == 1)

I8I = select(QuestionModel).where(QuestionModel.theme_id == 1).options(selectinload(QuestionModel.answers))

I9I = select(GameSessionModel).where(GameSessionModel.status != 'Complete')

I10I = update(GameSessionModel).where(GameSessionModel.id == 5).values(status='active', start_date=datetime.now())

I11I = GameSessionModel(chat_id=109470065,
                         status='test',
                         capitan_id=109470065,
                         start_date=datetime.now()
                         )

I12I = select(QuestionCGKModel).limit(NUM_OF_QUESTION)


question_list = [QuestionCGK(question_id=1, title='Один', answer=['северное сияние'], description='красивые'),
                 QuestionCGK(question_id=4, title='question1', answer=['answer1-1', 'answer1-2'], description='desc1'),
                 QuestionCGK(question_id=5, title='question2', answer=['answer2-1', 'answer2-2'], description='desc2'),
                 QuestionCGK(question_id=6, title='question3', answer=['answer3-1', 'answer3-2'], description='desc3'),
                 QuestionCGK(question_id=7, title='question4', answer=['answer4-1', 'answer4-2'], description='desc4')]

I13I = [GameSessionQuestionModel(question_id=i.question_id,
                                 game_session_id=1,
                                 ) for i in question_list]

I14I = select(GameSessionQuestionModel).where(GameSessionQuestionModel.game_session_id == 1)\
    .options(selectinload(GameSessionQuestionModel.question, GameSessionQuestionModel.session))


I15I = select(GameSessionModel).where(GameSessionModel.id == 1)

I16I = select(GameSessionModel).where(GameSessionModel.chat_id == 109470065, GameSessionModel.status != 'complete')

I17I = select(GameSessionQuestionModel).where(GameSessionQuestionModel.game_session_id == 1, GameSessionQuestionModel.status == None)\
            .options(selectinload(GameSessionQuestionModel.question)).limit(1)

I18I = select(TeamModel).where(TeamModel.session_id == 69)

async def async_main():
    engine = create_async_engine(DATABASE_URL, echo=False, future=True)

    async_session = sessionmaker(engine, expire_on_commit=False, class_=AsyncSession)

    # # MODIFICATION SECTION
    # # change required query here
    # query_variable = I1I
    # modification_variable = I1
    # async with async_session() as session:
    #     # initial_result = await session.execute(query_variable)
    #     # pprint(f"INITIAL VALUE: {initial_result.fetchall()}")
    #
    #     res = await session.execute(modification_variable)
    #     pprint(a := res.scalar())
    #     pprint(a)
    #
    #     # updated_result = await session.execute(query_variable)
    #     # pprint(f"UPDATED VALUE: {updated_result.fetchall()}")
    #
    #     await session.commit()

    # QUERIES SECTION
    # change required query here
    query = I18I
    async with async_session() as session:
        print(query)

        res: ChunkedIteratorResult = await session.execute(query)
        # pprint(res:=res.scalars().first().to_dc())
        # print(max(res.bot_point, res.team_point))
        # a = ListQuestionSchema().dumps(res.mappings().all())
        # print((question_model:=res.scalars().first()).status)
        # question_model.status = 'asked'
        # print(question_model.status)
        # for row in res.scalars().all():
        #
        #     # print(type(row))
        #     print(row)
        #     print(row.to_dc())
        pprint([row.to_dc() for row in res.scalars().all()])

    # # Update query
    # query = I10I
    # async with async_session() as session:
    #     print(query)
    #     await session.execute(query)
    #     await session.commit()

    # # ADD query
    # query = I13I
    # async with async_session.begin() as session:
    #     print(query)
    #     res = session.add_all(query)

    await engine.dispose()


if __name__ == "__main__":
    asyncio.run(async_main())

# print(I13I)
