module Views.Home exposing (..)

import Types exposing (..)
import Html exposing (Html, text, div, form, input, button, span)
import Html.Attributes exposing (type_, placeholder, value, class)
import Html.Events exposing (onSubmit, onInput)


view : Model -> Html Msg
view model =
    div [ class "flex justify-center" ]
        [ div [ class "relative w-60 bg-white pa3 br-pill ba b--light-gray" ] [ queryForm ]
        ]


queryForm : Html Msg
queryForm =
    form [ onSubmit SubmitLoginEmailForm ]
        [ input [ class "mh1 pv2 ph4 br-pill b--solid b--blue", type_ "text", placeholder "Type your country", onInput LoginEmailFormOnInput ] []
        , span [ class "br b--light-gray w1 mr3 pa2" ] []
        , input [ class "mh1 pv2 ph4 br-pill b--solid b--blue", type_ "text", placeholder "Activity", onInput LoginEmailFormOnInput ] []
        , span [ class "br b--light-gray w1 mr3 pa2" ] []
        , input [ class "mh1 pv2 ph4 br-pill b--solid b--blue", type_ "text", placeholder "Catergory", onInput LoginEmailFormOnInput ] []
        , div [ class "di pa3 br-100 bg-blue" ]
            [ button [ class "bg-blue white f5 metro bn", value "submit" ] [ text "Go" ]
            ]
        ]
