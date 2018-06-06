module Model exposing (..)

import Navigation
import Types exposing (..)
import CountrySelect
import ActivitySelect


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { location = location
      , email = ""
      , isLoggedIn = False
      , countryInputValue = ""
      , countrySelect = CountrySelect.initialModel
      , activitySelect = ActivitySelect.initialModel
      }
    , Cmd.none
    )
