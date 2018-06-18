module ComponentDataDecoder exposing (fetchComponentDataCmd)

import Http
import Types exposing (..)
import Json.Decode exposing (Decoder, string, bool, null, list, lazy, field, map, map4, at, oneOf, nullable, keyValuePairs, map2)


item : Decoder ComponentDataItem
item =
    map4 ComponentDataItem
        (field "id" nullableString)
        (field "enabled" bool)
        (field "name" nullableString)
        (field "children" (map ComponentDataChildren (list (lazy (\_ -> item)))))


countries : Decoder (List ( String, List String ))
countries =
    keyValuePairs (list string)


nullableString : Decoder String
nullableString =
    oneOf [ string, null "" ]


type alias Data =
    { taxonomy : ComponentDataItem
    , countries : List ( String, List String )
    }


data =
    map2 Data
        (field "taxonomy" item)
        (field "countries" countries)


fetchComponentData : Model -> String -> Http.Request Data
fetchComponentData model apiUrl =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Content-Type" "application/json" ]
        , url = model.config.apiBaseUrl ++ apiUrl
        , body = Http.emptyBody
        , expect = Http.expectJson (at [ "data" ] data)
        , timeout = Nothing
        , withCredentials = False
        }


fetchTaskCmd : (Result Http.Error Data -> Msg) -> Model -> String -> Cmd Msg
fetchTaskCmd msgConstructor model apiUrl =
    Http.send msgConstructor (fetchComponentData model apiUrl)


fetchComponentDataCmd : Model -> Cmd Msg
fetchComponentDataCmd model =
    fetchTaskCmd ComponentData model "/component-data"
