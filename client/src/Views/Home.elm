module Views.Home exposing (..)

import Types exposing (..)
import Html exposing (Html, text, div, form, input, button, span)
import Html.Attributes exposing (type_, placeholder, value, class)
import Html.Events exposing (onSubmit, onInput)
import CountrySelect
import ActivitySelect


view : Model -> Html Msg
view model =
    div [ class "flex justify-center" ]
        [ div [ class "relative w-60 bg-white pa3 br-pill ba b--light-gray" ]
            [ div [ class "pr3" ] [ queryForm model ]
            ]
        ]


queryForm : Model -> Html Msg
queryForm model =
    form [ onSubmit SubmitLoginEmailForm ]
        [ Html.map CountrySelectMsg (CountrySelect.view model.countrySelect)
        , divider
        , Html.map ActivitySelectMsg (ActivitySelect.view model.activitySelect inputClass)
        , divider
        , div [ class "w-30 fl" ]
            [ input
                [ class inputClass
                , type_ "text"
                , placeholder "Category"
                , onInput LoginEmailFormOnInput
                ]
                []
            ]
        , submitButton
        ]


divider : Html msg
divider =
    div [ class "w-05 fl h2 flex justify-center" ] [ div [ class "br b--light-gray w0 h2 mh0" ] [] ]


inputClass : String
inputClass =
    "w-100 h2 fl pv2 ph3 br-pill ba b--solid b--blue"


submitButton : Html msg
submitButton =
    div [ class "di pa2 absolute right--2 top-0 h3 w3" ]
        [ button [ class "br-100 bg-blue white f5 metro bn h-100 w-100", value "submit" ] [ text "Go" ]
        ]
