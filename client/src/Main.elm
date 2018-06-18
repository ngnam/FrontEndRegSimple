module Main exposing (..)

import Types exposing (..)
import View
import Model
import Update
import Navigation


---- PROGRAM ----


main : Program Model.Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { view = View.view
        , init = Model.init
        , update = Update.update
        , subscriptions = always Sub.none
        }
