module Helpers.HomeData exposing (getActivities, getCategories, getCountries)

import DataTypes exposing (HomeDataItem, Taxonomy, HomeDataChildren(..))
import ActivitySelect exposing (Activity, ActivityId)
import CountrySelect exposing (Country)


removeChildren : List Taxonomy -> List HomeDataItem
removeChildren taxonomies =
    taxonomies
        |> List.map
            (\taxonomy ->
                HomeDataItem
                    taxonomy.id
                    taxonomy.enabled
                    taxonomy.name
            )


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
            , children = HomeDataChildren []
            }
        |> getFirstLevelChildren
        |> removeChildren


getCountries : List ( String, List String ) -> List Country
getCountries countryList =
    countryList
        |> List.map
            (\( id, names ) ->
                { id = id
                , name = Maybe.withDefault "" (List.head names)
                }
            )
        |> List.sortBy .name
