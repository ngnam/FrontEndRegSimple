module QueryNavBar exposing (..)

import Html exposing (Html, nav, div, button, a, text)
import Html.Attributes exposing (class)
import Model exposing (Model, Msg(..))
import CountrySelect
import Helpers.CountrySelect exposing (getCountrySelect, getSelectedCountry)
import ActivitySelect
import CategorySelect
import FilterTextInput
import Set


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
            [ div [ class "bg-mid-gray br-pill pa2 w-90 ml2 ba b--moon-gray flex" ]
                [ div
                    [ class "w-20 mr2" ]
                    [ Html.map
                        ActivitySelectMsg
                        (ActivitySelect.view model.activitySelect options)
                    ]
                , div
                    [ class "w-20" ]
                    [ Html.map
                        CategorySelectMsg
                        (CategorySelect.view model.categorySelect options)
                    ]
                , divider
                , div
                    [ class "w-20" ]
                    [ Html.map
                        (CountrySelectMsg 0)
                        (CountrySelect.view
                            (getCountrySelect 0 model)
                            { excludedCountries = Set.empty, placeholderText = Nothing }
                        )
                    ]
                , div
                    [ class "w-20 ml2" ]
                    [ Html.map
                        (CountrySelectMsg 1)
                        (CountrySelect.view
                            (getCountrySelect 1 model)
                            { excludedCountries =
                                case getSelectedCountry 0 model of
                                    Just countryId ->
                                        Set.singleton countryId

                                    Nothing ->
                                        Set.empty
                            , placeholderText = Just "Compare with ..."
                            }
                        )
                    ]
                , divider
                , FilterTextInput.view model
                ]
            ]
