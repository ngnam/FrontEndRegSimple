module Types exposing (..)

import Navigation
import CountrySelect
import ActivitySelect exposing (Activity)
import CategorySelect exposing (Category)
import Dict exposing (Dict)
import Http


type alias ComponentDataItem =
    { id : String
    , enabled : Bool
    , name : String
    , children : ComponentDataChildren
    }


type alias Taxonomy =
    { id : String
    , enabled : Bool
    , name : String
    }


type ComponentDataChildren
    = ComponentDataChildren (List ComponentDataItem)


type alias Model =
    { location : Navigation.Location
    , search : Dict.Dict String (List String)
    , queryResults : String
    , componentData : ComponentDataItem
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
    | ComponentData (Result Http.Error ComponentDataItem)
    | NoOp
