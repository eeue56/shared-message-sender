module View exposing (..)

import Model exposing (..)
import Update exposing (..)
import Html exposing (Html)
import Element
import Element.Input
import Element.Events exposing (onClick)
import Element.Attributes exposing (px, width, height, fill)
import Style
import Color
import Style.Color as Color
import Style.Border as Border
import Style.Shadow as Shadow


type MyStyles
    = NoStyle
    | BorderedStyle


stylesheet : Style.StyleSheet MyStyles variation
stylesheet =
    Style.styleSheet
        [ Style.style NoStyle
            []
        , Style.style BorderedStyle
            [ Border.rounded 2
            , Color.border <| Color.rgb 0 0 0
            , Border.solid
            , Border.all 2
            ]
        ]


type alias ElementStyle variation =
    Element.Element MyStyles variation Msg


centeredText : String -> ElementStyle a
centeredText text =
    Element.text text
        |> Element.el NoStyle [ Element.Attributes.center, Element.Attributes.verticalCenter ]


viewUsername : Model Msg -> ElementStyle a
viewUsername model =
    Element.Input.text
        BorderedStyle
        [ Element.Attributes.width <| px 200
        , Element.Attributes.height <| px 40
        ]
        { onChange = SetUsername
        , value = model.username
        , label =
            centeredText "Recipient username:"
                |> Element.Input.labelLeft
        , options = []
        }
        |> Element.el NoStyle
            [ Element.Attributes.center
            , Element.Attributes.verticalCenter
            ]


viewPlatformChoice :
    String
    -> Element.Input.Choice String MyStyles a Msg
viewPlatformChoice choiceName =
    Element.Input.choice choiceName (centeredText choiceName)


viewPlatformSelect : Model Msg -> ElementStyle a
viewPlatformSelect model =
    Element.Input.select
        BorderedStyle
        [ Element.Attributes.width <| px 100
        , Element.Attributes.height <| px 20
        ]
        { label = Element.Input.labelAbove <| centeredText "Platform"
        , with = model.chosenPlatform
        , max = 5
        , options = []
        , menu =
            Element.Input.menu NoStyle
                [ Element.Attributes.width <| px 100 ]
                (List.map viewPlatformChoice model.platformChoices)
        }
        |> Element.el NoStyle
            [ Element.Attributes.width <| px 100
            , Element.Attributes.height <| px 60
            , Element.Attributes.paddingTop 50
            , Element.Attributes.paddingBottom 100
            , Element.Attributes.center
            , Element.Attributes.verticalCenter
            ]


viewMessage : Model Msg -> ElementStyle a
viewMessage model =
    Element.Input.multiline
        BorderedStyle
        [ Element.Attributes.width <| px 600
        , Element.Attributes.height <| px 300
        ]
        { onChange = SetMessage
        , value = model.message
        , label =
            centeredText "Message to send:"
                |> Element.Input.labelAbove
        , options = []
        }
        |> Element.el NoStyle
            [ Element.Attributes.center
            , Element.Attributes.verticalCenter
            , Element.Attributes.paddingTop 30
            , Element.Attributes.paddingBottom 30
            ]


viewSubmit : Model Msg -> ElementStyle a
viewSubmit model =
    Element.button
        BorderedStyle
        [ Element.Attributes.width <| px 200
        , Element.Attributes.height <| px 100
        , onClick Submit
        , Element.Attributes.center
        ]
        (centeredText "Submit")


viewModerator : Moderator -> ElementStyle a
viewModerator { name, hasChecked } =
    Element.Input.checkbox NoStyle
        [ Element.Attributes.center ]
        { onChange = ToggleConfirmation name
        , checked = hasChecked
        , label = Element.el NoStyle [] (Element.text name)
        , options = []
        }


viewWhoHasApproved : ElementStyle a
viewWhoHasApproved =
    Element.text "Who agrees with the above message?"
        |> Element.el
            NoStyle
            [ Element.Attributes.paddingTop 10
            , Element.Attributes.paddingBottom 10
            ]


viewModerators : Model Msg -> ElementStyle a
viewModerators model =
    Element.column
        NoStyle
        [ Element.Attributes.center ]
        (viewWhoHasApproved :: List.map viewModerator model.moderators)
        |> Element.el NoStyle [ Element.Attributes.center, Element.Attributes.verticalCenter ]


viewErrors : Model Msg -> ElementStyle a
viewErrors model =
    Element.text model.errors


viewMainColumn : Model Msg -> ElementStyle a
viewMainColumn model =
    Element.wrappedColumn
        NoStyle
        [ Element.Attributes.verticalSpread, height fill, width fill ]
        [ Element.el NoStyle [] (Element.text "")
        , viewErrors model
        , viewUsername model
        , viewPlatformSelect model
        , viewMessage model
        , viewSubmit model
        , viewModerators model
        , Element.el NoStyle [] (Element.text "")
        ]


view : Model Msg -> Html Msg
view model =
    viewMainColumn model
        |> Element.layout stylesheet
