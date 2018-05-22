module Types exposing (..)

import Navigation


type alias Model =
    { location : Navigation.Location, email : String }


type Msg
    = UrlChange Navigation.Location
    | SubmitLoginEmailForm
    | LoginEmailFormOnInput String
    | RequestLoginCodeCompleted
    | NoOp
