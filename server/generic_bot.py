"""
This file contains the bot itself

To add a new function:
    - add an entry in `known_functions`. The key is the command the bot
        will know, the value is the command to run
    - You must add type annotitions for the bot to match args up correctly

"""

from typing import List, Union, NamedTuple

from better_slack import BetterSlack


class GenericSlackBot(BetterSlack):
    _user_id = None
    _last_sender = None

    def __init__(self, *args, **kwargs):
        BetterSlack.__init__(self, *args, **kwargs)
        self.name = 'generic-slack-bot'

    def is_direct_message(self, channel):
        """ Direct messages start with `D`
        """
        return channel.startswith('D')

    def was_directed_at_me(self, text):
        return text.startswith(f'<@{self.user_id}>')

    def parse_direct_message(self, message):
        pass

    async def main_loop(self):
        await BetterSlack.main_loop(
            self,
            parser=self.parse_messages,
            on_tick=self.on_tick
        )

    def on_tick(self):
        pass

    @property
    def user_id(self):
        if self._user_id is None:
            data = self.connected_user(self.name)
            self._user_id = data

        return self._user_id

    def parse(self, text, channel):
        """ Take text, a default channel,
        """

        # we only tokenize those that talk to me
        if self.was_directed_at_me(text):
            user_id_string = f'<@{self.user_id}>'

            if text.startswith(user_id_string):
                text = text[len(user_id_string):].strip()
        else:
            return None


    def parse_message(self, message):
        # if we don't have any of the useful data, return early
        print(message)
        if 'type' not in message or 'text' not in message:
            return None

        if message['type'] != 'message':
            return None

        print(message)
        self._last_sender = message.get('user', None)

        # if it's a direct message, parse it differently
        if self.is_direct_message(message['channel']):
            return self.parse_direct_message(message)

    def parse_messages(self, messages):
        for message in messages:
            self.parse_message(message)

  

class BotExtension(GenericSlackBot):
    def __init__(self, *args, **kwargs):
        pass
