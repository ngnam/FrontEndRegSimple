module Views.Home exposing (..)

import Types exposing (..)
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
    div [ class "vh-75" ]
        [ section [ class "mb3 flex justify-center" ]
            [ div [ class "flex justify-center flex-column w-30" ]
                [ img [ class "w-100 mb2", src "/assets/logos/logo_icon+text_new.png" ] []
                , h1 [ class "metro-i" ] [ text "Regulation. Simplified." ]
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
    (activitySelect.selected /= -1) && (countrySelect.selected /= -1) && not (List.isEmpty categorySelect.selected)


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
                ++ .id (Maybe.withDefault emptyCountry model.countrySelect.selectedCountry)

        categories =
            List.foldr (\category accum -> accum ++ "&categories[]=" ++ category.id) "" model.categorySelect.selected

        queryString =
            countries ++ categories
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
