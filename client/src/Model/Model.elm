module Model exposing (Msg(..), Model, Flags, init)

import Navigation
import CountrySelect
import ActivitySelect
import CategorySelect
import Helpers.Routing exposing (parseLocation)
import Dict
import DataTypes exposing (QueryResults, Taxonomy, HomeDataResults, HomeDataChildren(..))
import Http


type Msg
    = UrlChange Navigation.Location
    | SubmitLoginEmailForm
    | LoginEmailFormOnInput String
    | RequestLoginCodeCompleted
    | CountrySelectMsg CountrySelect.Msg
    | ActivitySelectMsg ActivitySelect.Msg
    | CategorySelectMsg CategorySelect.Msg
    | FetchQueryResults (Result Http.Error QueryResults)
    | HomeData (Result Http.Error HomeDataResults)
    | NoOp


type alias Flags =
    { apiBaseUrl : String }


type alias Model =
    { location : Navigation.Location
    , search : Dict.Dict String (List String)
    , queryResults : QueryResults
    , homeData : Taxonomy
    , countries : List ( String, List String )
    , email : String
    , isLoggedIn : Bool
    , countrySelect : CountrySelect.Model
    , activitySelect : ActivitySelect.Model
    , categorySelect : CategorySelect.Model
    , config : { apiBaseUrl : String }
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    ( { location = parseLocation location
      , search = Dict.empty
      , queryResults = { nMatches = 0, totalMatches = 0, maxScore = 0, matches = [] }
      , homeData =
            { id = ""
            , enabled = False
            , name = ""
            , children = HomeDataChildren []
            }
      , countries = []
      , email = ""
      , isLoggedIn = False
      , countrySelect = CountrySelect.initialModel
      , activitySelect = ActivitySelect.initialModel
      , categorySelect = CategorySelect.initialModel
      , config = { apiBaseUrl = flags.apiBaseUrl }
      }
    , redirectIfRoot location
    )


redirectIfRoot : Navigation.Location -> Cmd msg
redirectIfRoot { pathname } =
    if pathname == "/" then
        Navigation.modifyUrl "/#/"
    else
        Cmd.none
