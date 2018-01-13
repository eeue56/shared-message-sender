module Update exposing (..)

import Model exposing (..)
import Element.Input exposing (SelectMsg)
import Json.Decode
import Http


type Msg
    = NoOp
    | SetUsername String
    | SetPlatforms (List String)
    | SetPlatformChoice (SelectMsg String)
    | SetMessage String
    | Submit
    | SetModerators (List Moderator)
    | ServerError Http.Error
    | ToggleConfirmation String Bool


update : Msg -> Model Msg -> ( Model Msg, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SetUsername username ->
            ( { model | username = username }, Cmd.none )

        SetPlatforms platforms ->
            ( { model | platformChoices = platforms }, Cmd.none )

        SetMessage message ->
            ( { model | message = message }, Cmd.none )

        SetPlatformChoice got ->
            ( { model | chosenPlatform = Element.Input.updateSelection got model.chosenPlatform }, Cmd.none )

        SetModerators moderators ->
            ( { model | moderators = moderators }, Cmd.none )

        Submit ->
            ( model, Cmd.none )

        ServerError error ->
            ( { model | errors = toString error }, Cmd.none )

        ToggleConfirmation name state ->
            ( { model
                | moderators =
                    List.map
                        (\moderator ->
                            if moderator.name == name then
                                { moderator | hasChecked = state }
                            else
                                moderator
                        )
                        model.moderators
              }
            , Cmd.none
            )


init : ( Model Msg, Cmd Msg )
init =
    ( { username = ""
      , platformChoices = [ "Example" ]
      , chosenPlatform = Element.Input.dropMenu Nothing SetPlatformChoice
      , message = ""
      , moderators = []
      , errors = ""
      }
    , Cmd.batch
        [ getModerators
        , getPlatforms
        ]
    )


subscriptions : Model Msg -> Sub msg
subscriptions model =
    Sub.none


send : (a -> Msg) -> Http.Request a -> Cmd Msg
send msg request =
    let
        chooseResponse result =
            case result of
                Err e ->
                    ServerError e

                Ok v ->
                    msg v
    in
        Http.send chooseResponse request


getModerators : Cmd Msg
getModerators =
    Http.get "/moderators" decodeModerators
        |> send SetModerators


getPlatforms : Cmd Msg
getPlatforms =
    Http.get "/platforms" (Json.Decode.list Json.Decode.string)
        |> send SetPlatforms
