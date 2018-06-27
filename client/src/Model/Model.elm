module Model exposing (Msg(..), Model, Flags, init)

import Navigation
import CountrySelect
import ActivitySelect
import CategorySelect exposing (CategoryId)
import Helpers.Routing exposing (parseLocation)
import Dict
import Set
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
    | SetActiveCategory CategoryId
    | CategoryRemoveClick CategoryId
    | CategorySubMenuClick CategoryId
    | AccordionToggleClick ( String, Int )
    | Copy String
    | NoOp


type alias Flags =
    { apiBaseUrl : String, clientBaseUrl : String }


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
    , activeCategory : Maybe CategoryId
    , categorySubMenuOpen : Maybe CategoryId
    , accordionsOpen : Set.Set ( String, Int )
    , config : { apiBaseUrl : String }
    , navCount : Int
    , config : Flags
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
            , description = ""
            , children = HomeDataChildren []
            }
      , countries = []
      , email = ""
      , isLoggedIn = False
      , countrySelect = CountrySelect.initialModel
      , activitySelect = ActivitySelect.initialModel
      , categorySelect = CategorySelect.initialModel
      , activeCategory = Nothing
      , categorySubMenuOpen = Nothing
      , accordionsOpen = Set.empty
      , navCount = 0
      , config = { apiBaseUrl = flags.apiBaseUrl, clientBaseUrl = flags.clientBaseUrl }
      }
    , redirectIfRoot location
    )


redirectIfRoot : Navigation.Location -> Cmd msg
redirectIfRoot { hash, href } =
    if hash == "" then
        Navigation.modifyUrl "/#/"
    else
        Navigation.modifyUrl href
