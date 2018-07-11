module Model exposing (Msg(..), Model, Flags, init)

import Navigation
import Debouncer
import Time
import CountrySelect exposing (Country)
import ActivitySelect
import CategorySelect exposing (CategoryId)
import Helpers.Routing exposing (parseLocation)
import Dict exposing (Dict)
import Set
import RemoteData exposing (RemoteData(..), WebData)
import DataTypes
    exposing
        ( QueryResults
        , QueryResult
        , Taxonomy
        , AppDataResults
        , AppDataChildren(..)
        , SearchParsed
        , AppData
        , CountriesDictList
        , AccordionsOpen
        , User
        , Email
        , SnippetId
        , FeedbackResults
        , FeedbackType
        )


type Msg
    = UrlChange Navigation.Location
    | DebouncerSelfMsg (Debouncer.SelfMsg Msg)
    | LoginEmailFormOnInput Email
    | LoginEmailFormOnSubmit
    | LoginEmailFormOnResponse (WebData User)
    | LoginCodeFormOnInput String
    | LoginCodeFormOnSubmit
    | LoginCodeFormOnResponse (WebData User)
    | CountrySelectMsg Int CountrySelect.Msg
    | ActivitySelectMsg ActivitySelect.Msg
    | CategorySelectMsg CategorySelect.Msg
    | FetchQueryResults (WebData QueryResults)
    | FetchAppData (WebData AppDataResults)
    | SetActiveCategory CategoryId
    | FilterTextOnInput String
    | OnQueryUpdate
    | SnippetRejectClick ( SnippetId, Int )
    | FeedbackRequest FeedbackType (WebData FeedbackResults)
    | CategoryRemoveClick CategoryId
    | CategorySubMenuClick CategoryId
    | AccordionToggleClick SnippetId
    | QueryResultListRemoveClick Int
    | Copy String
    | NoOp


type alias Flags =
    { apiBaseUrl : String, clientBaseUrl : String }


type alias Model =
    { location : Navigation.Location
    , debouncer : Debouncer.DebouncerState
    , search : SearchParsed
    , queryResults : WebData QueryResults
    , appData : WebData AppData
    , email : Email
    , isLoggedIn : Bool
    , countrySelect : Dict Int CountrySelect.Model
    , activitySelect : ActivitySelect.Model
    , categorySelect : CategorySelect.Model
    , activeCategory : Maybe CategoryId
    , filterText : String
    , categorySubMenuOpen : Maybe CategoryId
    , accordionsOpen : AccordionsOpen
    , config : { apiBaseUrl : String }
    , navCount : Int
    , config : Flags
    , loginCodeResponse : WebData User
    , loginEmailResponse : WebData User
    , loginCode : String
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    ( { location = parseLocation location
      , search = Dict.empty
      , debouncer = Debouncer.create (0.3 * Time.second)
      , queryResults = NotAsked
      , appData = Loading
      , email = ""
      , loginCode = ""
      , isLoggedIn = False
      , countrySelect =
            Dict.fromList
                [ ( 0, CountrySelect.initialModel ), ( 1, CountrySelect.initialModel ) ]
      , activitySelect = ActivitySelect.initialModel
      , categorySelect = CategorySelect.initialModel
      , activeCategory = Nothing
      , filterText = ""
      , categorySubMenuOpen = Nothing
      , accordionsOpen = Set.empty
      , navCount = 0
      , config = { apiBaseUrl = flags.apiBaseUrl, clientBaseUrl = flags.clientBaseUrl }
      , loginCodeResponse = NotAsked
      , loginEmailResponse = NotAsked
      }
    , redirectIfRoot location
    )


redirectIfRoot : Navigation.Location -> Cmd msg
redirectIfRoot { hash, href } =
    if hash == "" then
        Navigation.modifyUrl "/#/"
    else
        Navigation.modifyUrl href
