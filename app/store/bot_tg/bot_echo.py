import asyncio
from datetime import datetime
from app.store.tg_api.accessor import TgClient


token_tg = '5799107708:AAHojRBpqBB0GTDzdCteATQKu-mLIywRwrA'


def run_echo():
    c = TgClient(token=token_tg)
    flag = True

    async def echo():
        offset = 0
        while flag:
            res = await c.get_updates_in_objects(offset=offset, timeout=60)
            for item in res.result:
                offset = item.update_id + 1
                if item.message:
                    # await c.send_message(item.message.chat.id, item.message.text)
                    print(item.message.chat.id, item.message.text)
                elif item.callback_query:
                    # await c.send_message(item.callback_query.from_.id, item.callback_query.from_.first_name)
                    print(item.callback_query.from_.id, item.callback_query.from_.first_name)




    loop = asyncio.get_event_loop()
    try:
        loop.create_task(echo())
        loop.run_forever()
    except KeyboardInterrupt:
        flag = False
        print("\nstopping", datetime.now())
        loop.run_until_complete(echo())
        print('bot stopped', datetime.now())


if __name__ == '__main__':
    run_echo()
