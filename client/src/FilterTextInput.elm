module FilterTextInput exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes.Aria exposing (..)
import Model exposing (Model, Msg(FilterTextOnInput))


view : Model -> Html Msg
view model =
    let
        inputClass =
            classList
                [ ( "w-100 h2 pv2 pl4 bg-transparent bn f7 dark-gray metro placeholder--filter-text", True ) ]
    in
        div
            [ class "w-20 fl relative search" ]
            [ input
                [ inputClass
                , type_ "text"
                , onInput FilterTextOnInput
                , placeholder "Search results..."
                , value model.filterText
                , role "textbox"
                ]
                []
            ]
