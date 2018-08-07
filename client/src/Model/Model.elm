module Model exposing (Msg(..), Model, Flags, init, initialModel, initialSnippetFeedback)

import Navigation
import Debouncer
import Time
import CountrySelect exposing (Country)
import ActivitySelect
import CategorySelect
import Helpers.Routing exposing (parseLocation)
import Dict exposing (Dict)
import DictList exposing (DictList)
import Set
import RemoteData exposing (RemoteData(..), WebData)
import Json.Decode exposing (Value)
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
        , AnalyticsEvent
        , LocalStorageSession
        , ActivityId
        , CategoryId
        , CategoryCountry
        , SnippetFeedback
        , SnippetFeedbackData
        , SnippetBookmarkKey
        , SnippetBookmarkMetadata
        , SnippetBookmarks
        , DetailedSnippetBookmarks
        , QueryResultMatch
        )
import Decoders


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
    | SetActiveBookmark SnippetBookmarkKey
    | FilterTextOnInput String
    | OnQueryUpdate
    | SnippetSuggestClick SnippetFeedbackData
    | FeedbackRequest FeedbackType (WebData FeedbackResults)
    | AnalyticsEventRequest AnalyticsEvent
    | CategoryRemoveClick CategoryId
    | CategoryOptionsMenuSetFocus (Maybe CategoryId)
    | AccordionToggleClick SnippetId
    | QueryResultListRemoveClick CategoryCountry
    | SnippetFeedbackDialogOpenClick SnippetFeedbackData
    | SnippetFeedbackDialogCloseClick
    | SnippetOptionsMenuSetFocus (Maybe SnippetId)
    | SnippetBookmarkClick SnippetBookmarkKey Bool
    | SnippetBookmarkAdd SnippetBookmarkKey SnippetBookmarkMetadata
    | SnippetBookmarkRemove SnippetBookmarkKey
    | SnippetBookmarksHydrate SnippetBookmarks
    | SetDetailedSnippetBookmarks (List QueryResultMatch)
    | ActivityFeedbackClick ActivityId
    | ActivityMenuFeedbackToggleClick
    | CategoryFeedbackClick CategoryId
    | CategoryMenuFeedbackToggleClick
    | Copy String
    | LogoutClick
    | LogoutOnResponse (WebData String)
    | SnippetVoteUpClick ( SnippetId, CategoryId )
    | SnippetVoteDownClick ( SnippetId, CategoryId )
    | NoOp


type alias Config =
    { apiBaseUrl : String, clientBaseUrl : String }


type alias Flags =
    { config : Config
    , session : Value
    }


type alias Model =
    { location : Navigation.Location
    , debouncer : Debouncer.DebouncerState
    , search : SearchParsed
    , queryResults : WebData QueryResults
    , appData : WebData AppData
    , countrySelect : Dict Int CountrySelect.Model
    , activitySelect : ActivitySelect.Model
    , categorySelect : CategorySelect.Model
    , activeCategory : Maybe CategoryId
    , activeBookmark : Maybe SnippetBookmarkKey
    , filterText : String
    , categorySubMenuOpen : Maybe CategoryId
    , snippetOptionsMenuOpen : Maybe SnippetId
    , accordionsOpen : AccordionsOpen
    , config : Config
    , navCount : Int
    , config : Config
    , loginEmail : Email
    , loginEmailResponse : WebData User
    , loginCode : String
    , loginCodeResponse : WebData User
    , user : Maybe User
    , snippetFeedback : SnippetFeedback
    , snippetBookmarks : SnippetBookmarks
    , detailedSnippetBookmarks : DetailedSnippetBookmarks
    }


initialSnippetFeedback : SnippetFeedback
initialSnippetFeedback =
    { activityId = ""
    , activityMenuOpen = False
    , categoryIds = []
    , categoryMenuOpen = False
    , snippetData = Nothing
    , dialogOpen = False
    }


initialModel : Model
initialModel =
    { search = Dict.empty
    , debouncer = Debouncer.create (0.3 * Time.second)
    , queryResults = NotAsked
    , appData = Loading
    , loginEmail = ""
    , loginCode = ""
    , countrySelect =
        Dict.fromList
            [ ( 0, CountrySelect.initialModel ), ( 1, CountrySelect.initialModel ) ]
    , activitySelect = ActivitySelect.initialModel
    , categorySelect = CategorySelect.initialModel
    , activeCategory = Nothing
    , activeBookmark = Nothing
    , filterText = ""
    , categorySubMenuOpen = Nothing
    , snippetOptionsMenuOpen = Nothing
    , accordionsOpen = Set.empty
    , navCount = 0
    , loginCodeResponse = NotAsked
    , loginEmailResponse = NotAsked
    , location =
        { href = ""
        , host = ""
        , hostname = ""
        , protocol = ""
        , origin = ""
        , port_ = ""
        , pathname = ""
        , search = ""
        , hash = ""
        , username = ""
        , password = ""
        }
    , config = { apiBaseUrl = "", clientBaseUrl = "" }
    , user = Nothing
    , snippetFeedback = initialSnippetFeedback
    , snippetBookmarks = DictList.empty
    , detailedSnippetBookmarks = DictList.empty
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        session =
            Decoders.decodeSessionFromJson flags.session

        user =
            session
                |> Maybe.andThen .user

        snippetBookmarks =
            case session of
                Just session ->
                    session.snippetBookmarks

                Nothing ->
                    DictList.empty
    in
        ( { initialModel
            | location = parseLocation location
            , config = flags.config
            , user = user
            , snippetBookmarks = snippetBookmarks
          }
        , redirectIfRoot location
        )


redirectIfRoot : Navigation.Location -> Cmd msg
redirectIfRoot { hash, href } =
    if hash == "" then
        Navigation.modifyUrl "/#/"
    else
        Navigation.modifyUrl href
