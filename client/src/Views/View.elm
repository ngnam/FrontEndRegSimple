module View exposing (..)

import Router exposing (matchView)
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src, class)
import Util exposing (viewIf)
import Model exposing (Model, Msg(..))
import Views.Header as Header
import Views.Footer as Footer
import ContactBanner


headerRoutes : List String
headerRoutes =
    [ "#/", "#/about", "#/login" ]


view : Model -> Html Msg
view model =
    div []
        [ div
            [ class "bg-near-white min-vh-100 flex flex-column" ]
            [ ContactBanner.view
            , viewIf (List.member model.location.hash headerRoutes) (Header.view model)
            , matchView model
            , Footer.view model
            ]
        ]
