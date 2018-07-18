module Model exposing (Msg(..), Model, Flags, init, initialModel, initialSnippetFeedback)

import Navigation
import Debouncer
import Time
import CountrySelect exposing (Country)
import ActivitySelect
import CategorySelect
import Helpers.Routing exposing (parseLocation)
import Dict exposing (Dict)
import Set
import RemoteData exposing (RemoteData(..), WebData)
import Json.Decode exposing (Decoder, Value, decodeString, decodeValue, string, bool)
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
        , Session
        , ActivityId
        , CategoryId
        , CategoryCountry
        , DialogType(..)
        , SnippetFeedback
        , SnippetFeedbackData
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
    | FilterTextOnInput String
    | OnQueryUpdate
    | SnippetRejectClick SnippetFeedbackData
    | FeedbackRequest FeedbackType (WebData FeedbackResults)
    | AnalyticsEventRequest AnalyticsEvent
    | CategoryRemoveClick CategoryId
    | CategorySubMenuClick CategoryId
    | AccordionToggleClick SnippetId
    | QueryResultListRemoveClick CategoryCountry
    | DialogToggleClick DialogType SnippetFeedbackData
    | ActivityFeedbackClick ActivityId
    | ActivityMenuFeedbackToggleClick
    | CategoryFeedbackClick CategoryId
    | CategoryMenuFeedbackToggleClick
    | Copy String
    | LogoutClick
    | LogoutOnResponse (WebData String)
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
    , filterText : String
    , categorySubMenuOpen : Maybe CategoryId
    , accordionsOpen : AccordionsOpen
    , config : { apiBaseUrl : String }
    , navCount : Int
    , config : Config
    , loginEmail : Email
    , loginEmailResponse : WebData User
    , loginCode : String
    , loginCodeResponse : WebData User
    , session : Session
    , dialog : DialogType
    , snippetFeedback : SnippetFeedback
    }


initialSnippetFeedback : SnippetFeedback
initialSnippetFeedback =
    { activityId = ""
    , activityMenuOpen = False
    , categoryIds = []
    , categoryMenuOpen = False
    , snippetData = Nothing
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
    , filterText = ""
    , categorySubMenuOpen = Nothing
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
    , session = Nothing
    , dialog = NoDialog
    , snippetFeedback = initialSnippetFeedback
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    ( { initialModel
        | location = parseLocation location
        , config = flags.config
        , session =
            let
                decodeUserFromJson : Value -> Maybe User
                decodeUserFromJson json =
                    json
                        |> decodeValue string
                        |> Result.toMaybe
                        |> Maybe.andThen (decodeString Decoders.user >> Result.toMaybe)
            in
                decodeUserFromJson flags.session
      }
    , redirectIfRoot location
    )


redirectIfRoot : Navigation.Location -> Cmd msg
redirectIfRoot { hash, href } =
    if hash == "" then
        Navigation.modifyUrl "/#/"
    else
        Navigation.modifyUrl href
