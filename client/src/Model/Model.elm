module Model exposing (..)

import Navigation
import Types exposing (..)
import CountrySelect
import ActivitySelect
import CategorySelect
import Router exposing (parseLocation)
import Dict


type alias Flags =
    { apiBaseUrl : String }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    ( { location = parseLocation location
      , search = Dict.empty
      , queryResults = "NONE"
      , componentData = { id = "", enabled = False, name = "", children = ComponentDataChildren [] }
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
