module Views.Home exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, main_, text, div, section, form, img, input, h1, button, span, a, p)
import Html.Attributes exposing (type_, placeholder, value, src, class, href, tabindex, classList)
import Html.Attributes.Aria exposing (role)
import CountrySelect
import Helpers.CountrySelect exposing (getCountrySelect)
import ActivitySelect
import CategorySelect
import Helpers.QueryString exposing (queryString, queryValidation)
import Validation exposing (Validation(..))
import RemoteData exposing (RemoteData(..))
import Set
import DataTypes exposing (InputAlignment(..))


view : Model -> Html Msg
view model =
    main_ [ class "main--home" ]
        [ section [ class "h-50 flex justify-center" ]
            [ div [ class "flex justify-center flex-column w-25" ]
                [ img [ class "w-100 mb2", src "/assets/logos/logo-with-text.png" ] []
                , h1 [ class "mb2 metro-i" ] [ text "Regulation. Simplified." ]
                ]
            ]
        , section
            []
            [ div [ class "flex justify-center" ]
                [ div [ class "relative w-60 bg-white pa3 br-pill ba b--light-gray" ]
                    [ div [ class "pr3" ] [ queryForm model ]
                    ]
                ]
            ]
        , section
            [ class "flex justify-center items-center" ]
            [ case model.appData of
                Failure _ ->
                    div [ class "w-60 mt3" ] [ text "There was a problem connecting to our servers. Please check your internet connection and try again." ]

                _ ->
                    text ""
            ]
        ]


queryForm : Model -> Html Msg
queryForm model =
    form [ class "flex", role "search" ]
        [ div
            [ class "w-30" ]
            [ Html.map
                (CountrySelectMsg 0)
                (CountrySelect.view
                    (getCountrySelect 0 model)
                    { excludedCountries = Set.empty
                    , placeholderText = Nothing
                    , maxOptionsToShow = 8
                    , loadingInputInner = Nothing
                    , required = True
                    }
                )
            ]
        , divider
        , div
            [ class "w-30" ]
            [ Html.map
                ActivitySelectMsg
                (ActivitySelect.view
                    model.activitySelect
                    { inputAlignment = Center
                    , loadingButtonInner = Nothing
                    }
                )
            ]
        , divider
        , div
            [ class "w-30 relative" ]
            [ Html.map
                CategorySelectMsg
                (CategorySelect.view
                    model.categorySelect
                    { inputAlignment = Right
                    , loadingButtonInner = Nothing
                    }
                )
            ]
        , submitButton model
        ]


divider : Html msg
divider =
    div [ class "w-05 fl h2 flex justify-center" ] [ div [ class "br b--light-gray w0 h2 mh0" ] [] ]


submitButton : Model -> Html msg
submitButton model =
    let
        buttonChildClass =
            "flex justify-center items-center no-underline br-100 bg-blue white f5 metro bn h-100 w-100"
    in
        button
            [ class "di pa2 absolute right--2 top-0 h3 w3 bg-transparent bn"
            , tabindex -1
            , type_ "button"
            ]
            [ case queryValidation model of
                Valid ->
                    a
                        [ href ("/#/query?" ++ (queryString model))
                        , class buttonChildClass
                        , value "submit"
                        ]
                        [ text "Go" ]

                Invalid reason ->
                    span
                        [ class (buttonChildClass ++ "ma0 disabled bg-washed-blue")
                        ]
                        [ text "Go" ]
            ]
