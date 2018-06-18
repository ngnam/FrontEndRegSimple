module View exposing (..)

import Router exposing (matchView)
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src, class)
import Util exposing (viewIf)
import Types exposing (..)
import Views.Header as Header
import Views.Footer as Footer


view : Model -> Html Msg
view model =
    div [ class "bg-near-white min-vh-100" ]
        [ viewIf (not (String.contains "query" model.location.hash)) (Header.view model)
        , matchView model
        , Footer.view model
        ]
