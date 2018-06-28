module Model exposing (Msg(..), Model, Flags, init)

import Navigation
import Debouncer
import Time
import CountrySelect exposing (CountryId, CountryName, Country)
import CountrySelect2
import ActivitySelect
import CategorySelect exposing (CategoryId)
import Helpers.Routing exposing (parseLocation)
import Dict
import Set
import DataTypes
    exposing
        ( QueryResults
        , QueryResult
        , Taxonomy
        , HomeDataResults
        , HomeDataChildren(..)
        , SearchParsed
        )
import Http


type Msg
    = UrlChange Navigation.Location
    | DebouncerSelfMsg (Debouncer.SelfMsg Msg)
    | SubmitLoginEmailForm
    | LoginEmailFormOnInput String
    | RequestLoginCodeCompleted
    | CountrySelectMsg CountrySelect.Msg
    | CountrySelect2Msg CountrySelect2.Msg
    | ActivitySelectMsg ActivitySelect.Msg
    | CategorySelectMsg CategorySelect.Msg
    | FetchQueryResults (Result Http.Error QueryResults)
    | HomeData (Result Http.Error HomeDataResults)
    | SetActiveCategory CategoryId
    | FilterTextOnInput String
    | OnQueryUpdate
    | CategoryRemoveClick CategoryId
    | CategorySubMenuClick CategoryId
    | AccordionToggleClick ( String, Int )
    | QueryResultListRemoveClick Int
    | Copy String
    | NoOp


type alias Flags =
    { apiBaseUrl : String, clientBaseUrl : String }


type alias Model =
    { location : Navigation.Location
    , debouncer : Debouncer.DebouncerState
    , search : SearchParsed
    , queryResults : List QueryResult
    , homeData : Taxonomy
    , countries : Dict.Dict CountryId CountryName
    , email : String
    , isLoggedIn : Bool
    , countrySelect : CountrySelect.Model
    , countrySelect2 : CountrySelect2.Model
    , activitySelect : ActivitySelect.Model
    , categorySelect : CategorySelect.Model
    , activeCategory : Maybe CategoryId
    , filterText : String
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
      , debouncer = Debouncer.create (0.3 * Time.second)
      , queryResults = []
      , homeData =
            { id = ""
            , enabled = False
            , name = ""
            , description = ""
            , children = HomeDataChildren []
            }
      , countries = Dict.empty
      , email = ""
      , isLoggedIn = False
      , countrySelect = CountrySelect.initialModel
      , countrySelect2 = CountrySelect2.initialModel
      , activitySelect = ActivitySelect.initialModel
      , categorySelect = CategorySelect.initialModel
      , activeCategory = Nothing
      , filterText = ""
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
