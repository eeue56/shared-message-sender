from generic_bot import GenericSlackBot

import json
import asyncio

def setup():
    data = {}

    try:
        with open('priv.json') as f:
            data = json.load(f)
    except FileNotFoundError:
        print('not using config file..')
        print('some features may be disabled!')


    return data

def setup_slack(data):
    return GenericSlackBot(
        data.get('token', '')
    )


def main():
    data = setup()
    client = setup_slack(data)
    loop = asyncio.get_event_loop()
    client.send_message('eeue56', 'hello')
    loop.run_until_complete(client.main_loop())


if __name__ == '__main__':
    main()