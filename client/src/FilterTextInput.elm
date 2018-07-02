module FilterTextInput exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes.Aria exposing (..)
import Model exposing (Model, Msg(FilterTextOnInput))


view : Model -> Html Msg
view model =
    div
        [ class "w-20 fl relative icon icon--search z-0" ]
        [ input
            [ class "w-100 h2 pv2 pl4 bg-transparent bn f7 dark-gray metro truncate-ns placeholder--filter-text relative z-1"
            , type_ "text"
            , onInput FilterTextOnInput
            , placeholder "Search results..."
            , value model.filterText
            , role "textbox"
            ]
            []
        ]
