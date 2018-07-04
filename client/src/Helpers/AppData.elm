module Helpers.AppData exposing (getActivities, getCategories, getCountries, getCountriesDict, getCountryName)

import DataTypes exposing (AppDataItem, Taxonomy, AppDataChildren(..), CountryId, CountryName, CountriesDictList)
import ActivitySelect exposing (Activity, ActivityId)
import CountrySelect exposing (Country)
import Util exposing ((!!))
import Dict
import DictList


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
