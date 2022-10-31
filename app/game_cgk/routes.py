import typing

from app.game_cgk.views import QuestionCGKAddView, QuestionCGKAddAnswerView, QuestionRemoveView, \
    ListQuestionView

if typing.TYPE_CHECKING:
    from app.web.app import Application


def setup_routes(app: "Application"):
    app.router.add_view("/cgk.add_question", QuestionCGKAddView)
    app.router.add_view("/cgk.edit_question", QuestionCGKAddAnswerView)
    app.router.add_view("/cgk.remove_question", QuestionRemoveView)
    app.router.add_view("/cgk.all_question", ListQuestionView)
