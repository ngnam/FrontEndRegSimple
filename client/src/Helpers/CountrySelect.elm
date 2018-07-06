module Helpers.CountrySelect exposing (getCountrySelect, getSelectedCountry)

import Model exposing (Model)
import CountrySelect
import Dict
import DataTypes exposing (CountryId)


getCountrySelect : Int -> Model -> CountrySelect.Model
getCountrySelect index model =
    case Dict.get index model.countrySelect of
        Just countrySelect ->
            countrySelect

        Nothing ->
            CountrySelect.initialModel


getSelectedCountry : Int -> Model -> Maybe CountryId
getSelectedCountry index model =
    model
        |> getCountrySelect index
        |> .selected
