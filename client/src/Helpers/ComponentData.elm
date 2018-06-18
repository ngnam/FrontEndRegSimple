module Helpers.ComponentData exposing (getActivities, getCategories, getCountries)

import Types exposing (..)
import ActivitySelect exposing (Activity, ActivityId)
import CategorySelect exposing (Category, emptyCategory)
import CountrySelect exposing (Country)


removeChildren : List ComponentDataItem -> List Taxonomy
removeChildren taxonomies =
    taxonomies
        |> List.map
            (\taxonomy ->
                Taxonomy
                    taxonomy.id
                    taxonomy.enabled
                    taxonomy.name
            )


getFirstLevelChildren taxonomy =
    (\(ComponentDataChildren children) -> children) taxonomy.children


getActivities : ComponentDataItem -> List Taxonomy
getActivities taxonomy =
    taxonomy
        |> getFirstLevelChildren
        |> removeChildren


getCategories : ComponentDataItem -> ActivityId -> List Taxonomy
getCategories taxonomy activityId =
    taxonomy
        |> getFirstLevelChildren
        |> List.filter (\activity -> activity.id == activityId)
        |> List.head
        |> Maybe.withDefault
            { id = ""
            , name = ""
            , enabled = False
            , children = ComponentDataChildren []
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