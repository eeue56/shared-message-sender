module Model exposing (..)

import Element.Input
import Json.Decode
import Json.Encode


type alias Model msg =
    { errors : String
    , username : String
    , platformChoices : List String
    , chosenPlatform : Element.Input.SelectWith String msg
    , message : String
    , moderators : List Moderator
    }


type alias Moderator =
    { name : String
    , hasChecked : Bool
    }


decodeModerators : Json.Decode.Decoder (List Moderator)
decodeModerators =
    Json.Decode.list decodeModerator


decodeModerator : Json.Decode.Decoder Moderator
decodeModerator =
    Json.Decode.map2 Moderator
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "hasChecked" Json.Decode.bool)


encodeModerators : List Moderator -> Json.Encode.Value
encodeModerators moderators =
    List.map encodeModerator moderators
        |> Json.Encode.list


encodeModerator : Moderator -> Json.Encode.Value
encodeModerator moderator =
    Json.Encode.object
        [ ( "name", Json.Encode.string moderator.name )
        , ( "hasChecked", Json.Encode.bool moderator.hasChecked )
        ]
