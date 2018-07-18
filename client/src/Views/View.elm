module View exposing (..)

import Router exposing (matchView)
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src, class)
import Util exposing (viewIf)
import Model exposing (Model, Msg(..))
import DataTypes exposing (DialogType(NoDialog))
import Views.Header as Header
import Views.Footer as Footer
import ContactBanner
import Dialog.Dialog as Dialog


view : Model -> Html Msg
view model =
    div []
        [ div
            [ class "bg-near-white min-vh-100" ]
            [ ContactBanner.view
            , viewIf (not (model.location.hash == "#/query")) (Header.view model)
            , matchView model
            , Footer.view model
            , viewIf (model.dialog /= NoDialog) (Dialog.view model model.dialog)
            ]
        ]
