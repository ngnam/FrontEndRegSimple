module Types exposing (..)

import Navigation
import CountrySelect


type alias Model =
    { location : Navigation.Location
    , email : String
    , isLoggedIn : Bool
    , countryInputValue : String
    , countrySelect : CountrySelect.Model
    }


type Msg
    = UrlChange Navigation.Location
    | SubmitLoginEmailForm
    | LoginEmailFormOnInput String
    | CountryOnInput String
    | RequestLoginCodeCompleted
    | CountrySelectMsg CountrySelect.Msg
    | NoOp
