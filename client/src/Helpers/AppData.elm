module Helpers.AppData
    exposing
        ( getActivities
        , getCategories
        , getCountries
        , getCountriesDict
        , getCountryName
        , getActivityName
        , getCategoryById
        , getCategoriesFromIds
        , emptyCategory
        )

import CountrySelect exposing (Country)
import Util exposing ((!!))
import Dict
import DictList
import DataTypes
    exposing
        ( AppDataItem
        , Taxonomy
        , AppDataChildren(..)
        , CountryId
        , CountryName
        , CountriesDictList
        , Activity
        , ActivityId
        , CategoryId
        , Category
        )


removeChildren : List Taxonomy -> List AppDataItem
removeChildren taxonomies =
    taxonomies
        |> List.map
            (\taxonomy ->
                AppDataItem
                    taxonomy.id
                    taxonomy.enabled
                    taxonomy.name
                    taxonomy.description
            )


getFirstLevelChildren :
    Taxonomy
    ->
        List
            { enabled : Bool
            , id : String
            , name : String
            , description : String
            , children : AppDataChildren
            }
getFirstLevelChildren taxonomy =
    (\(AppDataChildren children) -> children) taxonomy.children


getActivities : Taxonomy -> List AppDataItem
getActivities taxonomy =
    taxonomy
        |> getFirstLevelChildren
        |> removeChildren


getCategories : Taxonomy -> ActivityId -> List AppDataItem
getCategories taxonomy activityId =
    taxonomy
        |> getFirstLevelChildren
        |> List.filter (\activity -> activity.id == activityId)
        |> List.head
        |> Maybe.withDefault
            { id = ""
            , name = ""
            , enabled = False
            , description = ""
            , children = AppDataChildren []
            }
        |> getFirstLevelChildren
        |> removeChildren


getCategoryById : List Category -> CategoryId -> Category
getCategoryById categories id =
    Maybe.withDefault emptyCategory (Dict.get id (toDict categories))


getCategoriesFromIds : List CategoryId -> List Category -> List Category
getCategoriesFromIds ids categories =
    List.map (getCategoryById categories) ids


emptyCategory : Category
emptyCategory =
    { name = "", id = "", enabled = False, description = "" }


toDict : List Category -> Dict.Dict String Category
toDict categories =
    categories
        |> List.map (\category -> ( category.id, category ))
        |> Dict.fromList


getCountries : List ( CountryId, List CountryName ) -> List Country
getCountries countryList =
    countryList
        |> List.map
            (\( id, names ) ->
                { id = id
                , name = Maybe.withDefault "" (List.head names)
                }
            )
        |> List.sortBy .name


getCountriesDict : List ( CountryId, List CountryName ) -> Dict.Dict CountryId CountryName
getCountriesDict countryList =
    countryList
        |> List.map
            (\( id, names ) ->
                ( id, Maybe.withDefault "" (0 !! names) )
            )
        |> Dict.fromList


getCountryName : CountryId -> CountriesDictList -> CountryName
getCountryName countryId countriesDictList =
    DictList.get countryId countriesDictList
        |> Maybe.andThen List.head
        |> Maybe.withDefault ""


getActivityName : Maybe ActivityId -> List Activity -> String
getActivityName maybeId activities =
    let
        defaultButtonText =
            "Choose an Activity"
    in
        case maybeId of
            Just id ->
                activities
                    |> List.filter (\activity -> activity.id == id)
                    |> List.head
                    |> Maybe.map .name
                    |> Maybe.withDefault defaultButtonText

            Nothing ->
                defaultButtonText
