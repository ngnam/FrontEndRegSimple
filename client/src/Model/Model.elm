module Model exposing (..)

import Navigation
import Types exposing (..)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { location = location, email = "", isLoggedIn = False }, Cmd.none )
