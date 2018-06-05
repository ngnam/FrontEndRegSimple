module Model exposing (..)

import CountrySelect
import Navigation
import Types exposing (..)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { location = location
      , email = ""
      , isLoggedIn = False
      , countryInputValue = ""
      , countrySelect = CountrySelect.initialModel
      }
    , Cmd.none
    )
