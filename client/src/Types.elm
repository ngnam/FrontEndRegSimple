module Types exposing (..)

import Navigation


type alias Model =
    { location : Navigation.Location }


type Msg
    = UrlChange Navigation.Location
    | NoOp
