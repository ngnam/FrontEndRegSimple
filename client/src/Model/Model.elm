module Model exposing (..)

import Navigation
import Types exposing (..)
import CountrySelect
import ActivitySelect
import CategorySelect
import Router exposing (parseLocation)
import Dict


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
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
      }
    , redirectIfRoot location
    )


redirectIfRoot : Navigation.Location -> Cmd msg
redirectIfRoot { pathname } =
    if pathname == "/" then
        Navigation.modifyUrl "/#/"
    else
        Cmd.none
