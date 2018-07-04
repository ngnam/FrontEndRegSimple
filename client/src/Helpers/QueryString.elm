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

        inValidQuery =
            noActivitySelected || noCategorySelected || noCountrySelected
    in
        case inValidQuery of
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
            List.foldr (\categoryId accum -> accum ++ "&categories[]=" ++ categoryId) "" model.categorySelect.selected

        filterText =
            "&filterText=" ++ model.filterText
    in
        country1 ++ country2 ++ activity ++ categories ++ filterText


removeFromSearchParsed : ( String, Int ) -> SearchParsed -> SearchParsed
removeFromSearchParsed ( key, i ) searchParsed =
    case Dict.get key searchParsed of
        Just oldParams ->
            Dict.update key
                (\mv ->
                    let
                        v =
                            Maybe.withDefault [] mv
                    in
                        Just ((List.take i v) ++ (List.drop (i + 1) v))
                )
                searchParsed

        Nothing ->
            searchParsed


removeFromQueryString : String -> ( String, Int ) -> String
removeFromQueryString queryString ( key, index ) =
    queryString
        |> parseParams
        |> removeFromSearchParsed ( key, index )
        |> searchParsedToQueryString


searchParsedToQueryString : SearchParsed -> String
searchParsedToQueryString searchParsed =
    let
        getParamList key =
            Maybe.withDefault [] (Dict.get key searchParsed)

        activityPart =
            "activity[]="
                ++ case 0 !! (getParamList "activity") of
                    Just activity ->
                        activity

                    Nothing ->
                        ""

        countriesPart =
            List.foldr
                (\categoryId accum -> accum ++ "&countries[]=" ++ categoryId)
                ""
                (getParamList "countries")

        categoriesPart =
            List.foldr
                (\categoryId accum -> accum ++ "&categories[]=" ++ categoryId)
                ""
                (getParamList "categories")
    in
        activityPart ++ countriesPart ++ categoriesPart
