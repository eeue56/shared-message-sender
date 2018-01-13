module Main exposing (..)

import Html
import View exposing (view)
import Update exposing (update, init, subscriptions, Msg)
import Model exposing (Model)


main : Program Never (Model Msg) Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
