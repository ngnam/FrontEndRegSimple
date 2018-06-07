module Model exposing (..)

import Navigation
import Types exposing (..)
import CountrySelect
import ActivitySelect
import CategorySelect


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { location = location
      , email = ""
      , isLoggedIn = False
      , countrySelect = CountrySelect.initialModel
      , activitySelect = ActivitySelect.initialModel
      , categorySelect = CategorySelect.initialModel
      }
    , Cmd.none
    )
