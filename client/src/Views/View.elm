module View exposing (..)

import Router exposing (matchView)
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src, class)
import Types exposing (..)
import Views.Header exposing (..)
import Views.Footer exposing (..)


view : Model -> Html Msg
view model =
    div [ class "bg-near-white min-vh-100" ]
        [ Views.Header.view model
        , img [ src "/logo.svg" ] []
        , h1 [] [ text "RegSimple" ]
        , matchView model
        , Views.Footer.view model
        ]
