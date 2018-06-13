module ComponentDataDecoder exposing (fetchComponentDataCmd)

import Http
import Types exposing (..)
import Json.Decode exposing (Decoder, string, bool, null, list, lazy, field, map, map4, at, oneOf, nullable)


item : Decoder ComponentDataItem
item =
    map4 ComponentDataItem
        (field "id" nullableString)
        (field "enabled" bool)
        (field "name" nullableString)
        (field "children" (map ComponentDataChildren (list (lazy (\_ -> item)))))


nullableString : Decoder String
nullableString =
    oneOf [ string, null "" ]


fetchComponentData : Model -> String -> Http.Request ComponentDataItem
fetchComponentData model apiUrl =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Content-Type" "application/json" ]
        , url = apiUrl
        , body = Http.emptyBody
        , expect = Http.expectJson (at [ "data" ] item)
        , timeout = Nothing
        , withCredentials = False
        }


fetchTaskCmd : (Result Http.Error ComponentDataItem -> Msg) -> Model -> String -> Cmd Msg
fetchTaskCmd msgConstructor model apiUrl =
    Http.send msgConstructor (fetchComponentData model apiUrl)


fetchComponentDataCmd : Model -> Cmd Msg
fetchComponentDataCmd model =
    fetchTaskCmd ComponentData model "http://localhost:4000/component-data"
