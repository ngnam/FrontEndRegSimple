module Helpers.QueryString exposing (queryString, removeFromQueryString)

import Model exposing (Model)
import Helpers.Routing exposing (parseParams)
import Dict
import DataTypes exposing (SearchParsed)
import Util exposing ((!!))


queryString : Model -> String
queryString model =
    let
        countries =
            "countries[]="
                ++ Maybe.withDefault "" model.countrySelect.selected

        countries2 =
            case model.countrySelect2.selected of
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
        countries ++ countries2 ++ activity ++ categories ++ filterText


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
