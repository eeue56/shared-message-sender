import os 

ENV = os.environ
PORT = int(ENV.get('PORT', '3000'))

from flask import Flask, jsonify, url_for
app = Flask(__name__)


@app.route("/")
def root():
    return app.send_static_file('index.html')


@app.route("/platforms") 
def platforms():
    return jsonify(['Slack'])


@app.route("/moderators") 
def moderators():
    MODERATORS = ENV.get('MODERATORS', '')
    mods = []
    split_moderators = (piece.strip() for piece in MODERATORS.split(','))

    for moderator in split_moderators:
        mods.append({
            'name': moderator,
            'hasChecked': False
        })

    return jsonify(mods)
 

if __name__ == '__main__':
    print('Starting...')
    app.run(port=PORT)