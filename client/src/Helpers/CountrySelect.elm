module Helpers.CountrySelect exposing (getCountrySelect, getSelectedCountry, getSelectedCountryIds)

import Model exposing (Model)
import CountrySelect
import Dict
import DictList
import DataTypes exposing (CountryId, CountryName)


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


getSelectedCountryIds : Model -> List CountryId
getSelectedCountryIds model =
    case Dict.get "countries" model.search of
        Just countries ->
            countries

        Nothing ->
            []



-- getCountryName : Model -> CountryId -> CountryName
-- getCountryName model countryId =
--     model
--         |> .appData
-- |> DictList.get countryId
