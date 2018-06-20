module Helpers.Routing exposing (parseLocation, parseParams, onUrlChange)

import Navigation exposing (Location)
import Util exposing (toKeyValuePair, toDict, (!!))
import Dict exposing (Dict)
import CategorySelect exposing (emptyCategory)


onPageLoad model =
    case model.location.hash of
        "#/query" ->
            { model
                | activeCategory =
                    Maybe.withDefault emptyCategory (0 !! model.categorySelect.selected)
            }

        _ ->
            model


onUrlChange location model =
    let
        parsedLocation =
            parseLocation location

        modelWithParsedLocation =
            { model
                | location = parsedLocation
                , search = parseParams parsedLocation.search
            }
    in
        onPageLoad modelWithParsedLocation


parseParams : String -> Dict String (List String)
parseParams queryString =
    queryString
        |> String.dropLeft 1
        |> String.split "&"
        |> List.filterMap toKeyValuePair
        |> toDict


parseLocation : Location -> Location
parseLocation location =
    { location
        | hash =
            String.split "?" location.hash
                |> List.head
                |> Maybe.withDefault ""
        , search =
            String.split "?" location.hash
                |> List.drop 1
                |> String.join "?"
                |> String.append "?"
    }
