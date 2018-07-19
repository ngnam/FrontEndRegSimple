module Helpers.QueryString exposing (queryString, removeFromQueryString, queryValidation)

import Model exposing (Model)
import Helpers.Routing exposing (parseParams)
import Helpers.CountrySelect exposing (getCountrySelect, getSelectedCountry)
import Dict
import DataTypes exposing (SearchParsed)
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
        country1 =
            "countries[]="
                ++ Maybe.withDefault "" (.selected (getCountrySelect 0 model))

        country2 =
            case .selected (getCountrySelect 1 model) of
                Nothing ->
                    ""

                Just "" ->
                    ""

                Just a ->
                    "&countries[]=" ++ a

        activity =
            "&activity[]="
                ++ Maybe.withDefault "" model.activitySelect.selected

        categories =
            List.foldl (\categoryId accum -> accum ++ "&categories[]=" ++ categoryId) "" model.categorySelect.selected

        filterText =
            "&filterText=" ++ model.filterText
    in
        country1 ++ country2 ++ activity ++ categories ++ filterText


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

        countriesPart =
            List.foldl
                (\countryId accum -> accum ++ "&countries[]=" ++ countryId)
                ""
                (getParamList "countries")
                |> String.dropLeft 1

        activityPart =
            "&activity[]="
                ++ case 0 !! (getParamList "activity") of
                    Just activity ->
                        activity

                    Nothing ->
                        ""

        categoriesPart =
            List.foldl
                (\categoryId accum -> accum ++ "&categories[]=" ++ categoryId)
                ""
                (getParamList "categories")
    in
        countriesPart ++ activityPart ++ categoriesPart
