module Types exposing (..)

import Navigation
import CountrySelect
import ActivitySelect
import CategorySelect
import Dict exposing (Dict)
import Http


type alias Model =
    { location : Navigation.Location
    , search : Dict.Dict String (List String)
    , queryResults : String
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
    | QueryResults (Result Http.Error String)
    | NoOp
