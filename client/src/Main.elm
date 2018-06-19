module Main exposing (..)

import Model exposing (init, Model, Msg(..), Flags)
import View
import Update
import Navigation


---- PROGRAM ----


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { view = View.view
        , init = Model.init
        , update = Update.update
        , subscriptions = always Sub.none
        }
