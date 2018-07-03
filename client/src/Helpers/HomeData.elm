module Helpers.HomeData exposing (getActivities, getCategories, getCountries, getCountriesDict, getCountryName)

import DataTypes exposing (HomeDataItem, Taxonomy, HomeDataChildren(..))
import ActivitySelect exposing (Activity, ActivityId)
import CountrySelect exposing (Country, CountryId, CountryName)
import Util exposing ((!!))
import Dict


removeChildren : List Taxonomy -> List HomeDataItem
removeChildren taxonomies =
    taxonomies
        |> List.map
            (\taxonomy ->
                HomeDataItem
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
            , children : HomeDataChildren
            }
getFirstLevelChildren taxonomy =
    (\(HomeDataChildren children) -> children) taxonomy.children


getActivities : Taxonomy -> List HomeDataItem
getActivities taxonomy =
    taxonomy
        |> getFirstLevelChildren
        |> removeChildren


getCategories : Taxonomy -> ActivityId -> List HomeDataItem
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
            , children = HomeDataChildren []
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


getCountryName countryId model =
    Maybe.withDefault "" (Dict.get countryId model.countries)
