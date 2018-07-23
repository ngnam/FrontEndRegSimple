module Helpers.Routing exposing (parseLocation, parseParams, onUrlChange)

import Navigation exposing (Location)
import Util exposing (toKeyValuePair, toDict, (!!), toDictList)
import DataTypes exposing (SearchParsed)
import Dict


onPageLoad model =
    case model.location.hash of
        "#/query" ->
            { model
                | activeCategory =
                    Dict.get "categories" model.search
                        |> Maybe.andThen ((!!) 0)
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
                , filterText = ""
            }
    in
        onPageLoad modelWithParsedLocation


parseParams : String -> SearchParsed
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
