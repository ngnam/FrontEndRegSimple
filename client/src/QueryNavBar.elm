module QueryNavBar exposing (..)

import Html exposing (Html, nav, div, button, a, text)
import Html.Attributes exposing (class)
import Model exposing (Model, Msg(..))
import CountrySelect
import ActivitySelect
import CategorySelect


divider : Html msg
divider =
    div [ class "w-05 fl h2 flex justify-center" ] [ div [ class "br b--light-gray w0 h2 mh0" ] [] ]


view : Model -> Html Msg
view model =
    let
        inputAlignment =
            case model.location.hash of
                "#/query" ->
                    "left"

                _ ->
                    "right"

        options =
            { inputAlignment = inputAlignment }
    in
        nav [ class "flex justify-between bb b--gray pv2" ]
            [ div [ class "bg-mid-gray br-pill pa2 w-70 ml2 ba b--moon-gray" ]
                [ Html.map ActivitySelectMsg (ActivitySelect.view model.activitySelect options)
                , Html.map CategorySelectMsg (CategorySelect.view model.categorySelect options)
                , divider
                , Html.map CountrySelectMsg (CountrySelect.view model.countrySelect)
                ]
            ]
