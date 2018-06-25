module Views.Home exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, text, div, section, form, img, input, h1, button, span, a, p)
import Html.Attributes exposing (type_, placeholder, value, src, class, href, tabindex)
import Html.Events exposing (onSubmit, onInput)
import Util exposing (viewIf)
import ClassNames exposing (classNames)
import CountrySelect exposing (emptyCountry)
import ActivitySelect
import CategorySelect


view : Model -> Html Msg
view model =
    div [ class "mb5" ]
        [ section [ class "mb4 flex justify-center" ]
            [ div [ class "flex justify-center flex-column w-25" ]
                [ img [ class "w-100 mb2", src "/assets/logos/logo_icon+text_new.png" ] []
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
        ]


queryForm : Model -> Html Msg
queryForm model =
    let
        inputAlignment =
            case model.location.hash of
                "#/query" ->
                    "left"

                "#/" ->
                    "right"

                _ ->
                    "right"

        options =
            { inputAlignment = inputAlignment }
    in
        form [ onSubmit SubmitLoginEmailForm ]
            [ Html.map CountrySelectMsg (CountrySelect.view model.countrySelect)
            , divider
            , Html.map ActivitySelectMsg (ActivitySelect.view model.activitySelect options)
            , divider
            , Html.map CategorySelectMsg (CategorySelect.view model.categorySelect options)
            , submitButton model
            ]


divider : Html msg
divider =
    div [ class "w-05 fl h2 flex justify-center" ] [ div [ class "br b--light-gray w0 h2 mh0" ] [] ]


checkFormValid : Model -> Bool
checkFormValid { activitySelect, countrySelect, categorySelect } =
    (activitySelect.selected /= Nothing) && (countrySelect.selectedCountry /= Nothing) && not (List.isEmpty categorySelect.selected)


submitButton : Model -> Html msg
submitButton model =
    let
        isFormValid =
            checkFormValid model

        buttonChildclass =
            classNames
                [ ( "flex justify-center items-center no-underline br-100 bg-blue white f5 metro bn h-100 w-100"
                  , True
                  )
                , ( "ma0 disabled bg-washed-blue"
                  , not isFormValid
                  )
                ]

        countries =
            "countries[]="
                ++ Maybe.withDefault "" model.countrySelect.selectedCountry

        activity =
            "&activity[]="
                ++ Maybe.withDefault "" model.activitySelect.selected

        categories =
            List.foldr (\categoryId accum -> accum ++ "&categories[]=" ++ categoryId) "" model.categorySelect.selected

        queryString =
            countries ++ activity ++ categories
    in
        button [ class "di pa2 absolute right--2 top-0 h3 w3 bg-transparent bn", tabindex -1 ]
            [ viewIf isFormValid
                (a
                    [ href ("/#/query?" ++ queryString)
                    , class buttonChildclass
                    , value "submit"
                    ]
                    [ text "Go" ]
                )
            , viewIf (not isFormValid)
                (span
                    [ class buttonChildclass
                    ]
                    [ text "Go" ]
                )
            ]
