module QueryNavBar exposing (..)

import Html exposing (Html, nav, div, button, a, text)
import Html.Attributes exposing (class)
import Types exposing (..)
import CountrySelect
import ActivitySelect
import CategorySelect


divider : Html msg
divider =
    div [ class "w-05 fl h2 flex justify-center" ] [ div [ class "br b--light-gray w0 h2 mh0" ] [] ]


inputClass : String
inputClass =
    "w-100 h2 fl pv2 ph3 br-pill ba b--solid b--blue"


view : Model -> Html Msg
view model =
    let
        inputAlignment =
            case model.location.hash of
                "#/query" ->
                    "left"

                _ ->
                    "right"
    in
        nav [ class "flex justify-between f6 bb b--gray pv2" ]
            [ div [ class "bg-mid-gray br-pill pa2 w-70 ml2" ]
                [ Html.map ActivitySelectMsg (ActivitySelect.view model.activitySelect inputAlignment inputClass)
                , Html.map CategorySelectMsg (CategorySelect.view model.categorySelect inputAlignment)
                , divider
                , Html.map CountrySelectMsg (CountrySelect.view model.countrySelect)
                ]
            ]
