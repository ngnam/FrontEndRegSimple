module Types exposing (..)

import Navigation
import CountrySelect
import ActivitySelect
import CategorySelect


type alias Model =
    { location : Navigation.Location
    , email : String
    , isLoggedIn : Bool
    , countrySelect : CountrySelect.Model
    , activitySelect : ActivitySelect.Model
    , categorySelect : CategorySelect.Model
    }


type Msg
    = UrlChange Navigation.Location
    | SubmitLoginEmailForm
    | LoginEmailFormOnInput String
    | RequestLoginCodeCompleted
    | CountrySelectMsg CountrySelect.Msg
    | ActivitySelectMsg ActivitySelect.Msg
    | CategorySelectMsg CategorySelect.Msg
    | NoOp
