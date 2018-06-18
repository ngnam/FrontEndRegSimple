module Helpers.Routing exposing (parseLocation, parseParams, onUrlChange)

import Navigation exposing (Location)
import Util exposing (toKeyValuePair, toDict)
import Dict exposing (Dict)


onUrlChange location model =
    { model
        | location = parseLocation location
        , search = parseParams (.search (parseLocation location))
    }


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
