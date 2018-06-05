module Views.Home exposing (..)

import Types exposing (..)
import Html exposing (Html, text, div, form, input, button, span)
import Html.Attributes exposing (type_, placeholder, value, class)
import Html.Events exposing (onSubmit, onInput)


view : Model -> Html Msg
view model =
    div [ class "flex justify-center" ]
        [ div [ class "relative w-60 bg-white pa3 br-pill ba b--light-gray" ]
            [ div [ class "pr3" ] [ queryForm ]
            ]
        ]


queryForm : Html Msg
queryForm =
    form [ onSubmit SubmitLoginEmailForm ]
        [ input
            [ class inputClass
            , type_ "text"
            , placeholder "Type your country"
            , onInput LoginEmailFormOnInput
            ]
            []
        , divider
        , input
            [ class inputClass
            , type_ "text"
            , placeholder "Activity"
            , onInput LoginEmailFormOnInput
            ]
            []
        , divider
        , input
            [ class inputClass
            , type_ "text"
            , placeholder "Catergory"
            , onInput LoginEmailFormOnInput
            ]
            []
        , submitButton
        ]


divider : Html msg
divider =
    div [ class "w-05 fl h2 flex justify-center" ] [ div [ class "br b--light-gray w0 h2 mh0" ] [] ]


inputClass : String
inputClass =
    "w-30 h2 fl pv2 ph3 br-pill ba b--solid b--blue"


submitButton : Html msg
submitButton =
    div [ class "di pa2 absolute right--2 top-0 h3 w3" ]
        [ button [ class "br-100 bg-blue white f5 metro bn h-100 w-100", value "submit" ] [ text "Go" ]
        ]
