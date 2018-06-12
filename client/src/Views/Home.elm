module Views.Home exposing (..)

import Types exposing (..)
import Html exposing (Html, text, div, form, input, button, span, a)
import Html.Attributes exposing (type_, placeholder, value, class, href)
import Html.Events exposing (onSubmit, onInput)
import CountrySelect
import ActivitySelect
import CategorySelect


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
        , Html.map CategorySelectMsg (CategorySelect.view model.categorySelect)
        , submitButton model
        ]


divider : Html msg
divider =
    div [ class "w-05 fl h2 flex justify-center" ] [ div [ class "br b--light-gray w0 h2 mh0" ] [] ]


inputClass : String
inputClass =
    "w-100 h2 fl pv2 ph3 br-pill ba b--solid b--blue"


submitButton : Model -> Html msg
submitButton model =
    let
        countries =
            "countries[]=" ++ toString model.countrySelect.selected

        categories =
            List.foldr (\category accum -> accum ++ "&categories[]=" ++ category.id) "" model.categorySelect.selected

        queryString =
            countries ++ categories
    in
        div [ class "di pa2 absolute right--2 top-0 h3 w3" ]
            [ a
                [ href ("/#/query?" ++ queryString)
                , class "flex justify-center items-center no-underline br-100 bg-blue white f5 metro bn h-100 w-100"
                , value "submit"
                ]
                [ text "Go" ]
            ]
