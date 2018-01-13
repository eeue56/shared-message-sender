#! /bin/bash

git checkout feature/deploy
git reset --hard master
elm-make src/Main.elm --output server/static/index.html
git add server/static/index.html
git commit server/static/index.html -m 'deployment'
git push -f heroku feature/deploy:master
git checkout master