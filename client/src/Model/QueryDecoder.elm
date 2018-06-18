module QueryDecoder exposing (fetchQueryResultsCmd)

import Http
import Types exposing (..)
import Json.Decode as Json


fetchQueryResults : Model -> String -> Http.Request String
fetchQueryResults model apiUrl =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Content-Type" "application/json" ]
        , url = model.config.apiBaseUrl ++ apiUrl ++ model.location.search
        , body = Http.emptyBody
        , expect = Http.expectJson (Json.at [ "data" ] Json.string)
        , timeout = Nothing
        , withCredentials = False
        }


fetchTaskCmd : (Result Http.Error String -> Msg) -> Model -> String -> Cmd Msg
fetchTaskCmd msgConstructor model apiUrl =
    Http.send msgConstructor (fetchQueryResults model apiUrl)


fetchQueryResultsCmd : Model -> Cmd Msg
fetchQueryResultsCmd model =
    fetchTaskCmd QueryResults model "/query"
