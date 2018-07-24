module Helpers.QueryString exposing (queryString, removeFromQueryString, queryValidation, queryStringFromRecord)

import Model exposing (Model)
import Helpers.Routing exposing (parseParams)
import Helpers.CountrySelect exposing (getCountrySelect, getSelectedCountry, getSelectedCountryIds)
import Dict
import DataTypes exposing (SearchParsed, CountryId, CategoryId, ActivityId)
import Util exposing ((!!))
import Validation exposing (Validation(..))


queryValidation : Model -> Validation
queryValidation model =
    let
        noActivitySelected =
            model.activitySelect.selected == Nothing

        noCategorySelected =
            List.isEmpty model.categorySelect.selected

        noCountrySelected =
            getSelectedCountry 0 model == Nothing

        validationText =
            if noActivitySelected then
                "Please select an Activity"
            else if noCategorySelected then
                "Please select a Category"
            else if noCountrySelected then
                "Please select a Country"
            else
                ""

        invalidQuery =
            noActivitySelected || noCategorySelected || noCountrySelected
    in
        case invalidQuery of
            True ->
                Invalid validationText

            False ->
                Valid


queryString : Model -> String
queryString model =
    let
        countries =
            List.filterMap
                identity
                [ .selected (getCountrySelect 0 model)
                , .selected (getCountrySelect 1 model)
                ]
    in
        queryStringFromRecord
            { countries = countries
            , categories = model.categorySelect.selected
            , activity = [ Maybe.withDefault "" model.activitySelect.selected ]
            , filterText = model.filterText
            }


removeFromSearchParsed : ( String, String ) -> SearchParsed -> SearchParsed
removeFromSearchParsed ( key, val ) searchParsed =
    case Dict.get key searchParsed of
        Just oldParams ->
            Dict.update key
                (\maybeList ->
                    let
                        list_ =
                            Maybe.withDefault [] maybeList
                    in
                        Just <|
                            List.filter
                                (\el -> el /= val)
                                list_
                )
                searchParsed

        Nothing ->
            searchParsed


removeFromQueryString : String -> ( String, String ) -> String
removeFromQueryString queryString ( key, val ) =
    queryString
        |> parseParams
        |> removeFromSearchParsed ( key, val )
        |> searchParsedToQueryString


searchParsedToQueryString : SearchParsed -> String
searchParsedToQueryString searchParsed =
    let
        getParamList key =
            Maybe.withDefault [] (Dict.get key searchParsed)
    in
        queryStringFromRecord
            { countries = getParamList "countries"
            , activity = getParamList "activity"
            , categories = getParamList "categories"
            , filterText = ""
            }


queryStringFromRecord :
    { countries : List CountryId
    , categories : List CategoryId
    , activity : List ActivityId
    , filterText : String
    }
    -> String
queryStringFromRecord { countries, categories, activity, filterText } =
    let
        makePart key list =
            List.foldl (\id accum -> accum ++ key ++ "[]=" ++ id ++ "&") "" list

        filterTextPart =
            if filterText == "" then
                ""
            else
                "filterText=" ++ filterText ++ "&"
    in
        makePart "countries" countries
            ++ makePart "activity" activity
            ++ makePart "categories" categories
            ++ filterTextPart
            |> String.dropRight 1
