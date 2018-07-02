module Views.Home exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, text, div, section, form, img, input, h1, button, span, a, p)
import Html.Attributes exposing (type_, placeholder, value, src, class, href, tabindex, classList)
import Html.Attributes.Aria exposing (role)
import Html.Events exposing (onSubmit, onInput)
import Util exposing (viewIf)
import CountrySelect
import Helpers.CountrySelect exposing (getCountrySelect)
import ActivitySelect
import CategorySelect
import Helpers.QueryString exposing (queryString)
import Set


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
        form [ class "flex", role "search", onSubmit SubmitLoginEmailForm ]
            [ div
                [ class "w-30" ]
                [ Html.map
                    (CountrySelectMsg 0)
                    (CountrySelect.view
                        (getCountrySelect 0 model)
                        { excludedCountries = Set.empty, placeholderText = Nothing }
                    )
                ]
            , divider
            , div
                [ class "w-30" ]
                [ Html.map ActivitySelectMsg (ActivitySelect.view model.activitySelect options) ]
            , divider
            , div
                [ class "w-30 relative" ]
                [ Html.map CategorySelectMsg (CategorySelect.view model.categorySelect options) ]
            , submitButton model
            ]


divider : Html msg
divider =
    div [ class "w-05 fl h2 flex justify-center" ] [ div [ class "br b--light-gray w0 h2 mh0" ] [] ]


checkFormValid : Model -> Bool
checkFormValid model =
    model.activitySelect.selected
        /= Nothing
        && .selected (getCountrySelect 0 model)
        /= Nothing
        && not (List.isEmpty model.categorySelect.selected)


submitButton : Model -> Html msg
submitButton model =
    let
        isFormValid =
            checkFormValid model

        buttonChildclass =
            classList
                [ ( "flex justify-center items-center no-underline br-100 bg-blue white f5 metro bn h-100 w-100"
                  , True
                  )
                , ( "ma0 disabled bg-washed-blue"
                  , not isFormValid
                  )
                ]
    in
        button [ class "di pa2 absolute right--2 top-0 h3 w3 bg-transparent bn", tabindex -1 ]
            [ viewIf isFormValid
                (a
                    [ href ("/#/query?" ++ (queryString model))
                    , buttonChildclass
                    , value "submit"
                    ]
                    [ text "Go" ]
                )
            , viewIf (not isFormValid)
                (span
                    [ buttonChildclass
                    ]
                    [ text "Go" ]
                )
            ]
