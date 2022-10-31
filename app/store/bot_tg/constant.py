# Переменные для игры
from datetime import datetime, timedelta

# Задержи между сменами этапов для основной игры:

WIN_POINT = 3
NUM_OF_QUESTION = WIN_POINT * 2 + 1
TIME_TO_TG_SERVER = 5  # разница с временм сервера TG и MSK 3 часа + 5 секунд
TIME_TO_ACTIVE = 5  # время на сбор команды
TIME_TO_ASKED = 2  # время на выбор ответа из базы
TIME_TO_RESPONSE = 5  # время обсуждения вопроса
TIME_TO_GRAB = 10  # время на выбор капитаном отвечающего
TIME_TO_ANSWERED = 15  # время на ответ
TIME_TO_CHECKING = 5  # проверка верного ответа
TIME_TO_CHECKED = 5  # вывод результата в чат


def check_time(time, checked_time):
    return (datetime.now() - time) / timedelta(seconds=1) >= checked_time
