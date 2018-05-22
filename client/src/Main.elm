module Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Types exposing (..)
import Router exposing (..)
import View
import Model
import Update
import Navigation


---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { view = View.view
        , init = Model.init
        , update = Update.update
        , subscriptions = always Sub.none
        }
