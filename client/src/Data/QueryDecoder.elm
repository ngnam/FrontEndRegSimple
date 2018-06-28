module QueryDecoder exposing (requestCmd)

import Http
import Model exposing (Model, Msg(..))
import DataTypes exposing (QueryResults, QueryResult, QueryResultMatch, QueryResultMatchBody)
import Json.Decode exposing (Decoder, list, int, float, string, at, oneOf, null, nullable)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


request : Model -> Http.Request QueryResults
request model =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Content-Type" "application/json" ]
        , url = model.config.apiBaseUrl ++ "/query" ++ model.location.search
        , body = Http.emptyBody
        , expect = Http.expectJson (at [ "data" ] decoder)
        , timeout = Nothing
        , withCredentials = False
        }


nullableString : Decoder String
nullableString =
    oneOf [ string, null "" ]


requestCmd : Model -> Cmd Msg
requestCmd model =
    Http.send FetchQueryResults (request model)


matchBodyDecoder : Decoder QueryResultMatchBody
matchBodyDecoder =
    decode QueryResultMatchBody
        |> required "tags" (list string)
        |> required "text" string
        |> required "offset" int
        |> required "summary" string
        |> required "url" string
        |> required "page" int


matchDecoder : Decoder QueryResultMatch
matchDecoder =
    decode QueryResultMatch
        |> required "score" float
        |> required "title" string
        |> required "type" nullableString
        |> required "country" string
        |> required "year" (nullable int)
        |> required "url" string
        |> required "id" string
        |> optional "body" (list matchBodyDecoder) []


queryResultDecoder : Decoder QueryResult
queryResultDecoder =
    decode QueryResult
        |> required "n_matches" int
        |> required "total_matches" int
        |> required "max_score" (nullable float)
        |> required "matches" (list matchDecoder)


decoder : Decoder QueryResults
decoder =
    decode QueryResults
        |> required "results" (list queryResultDecoder)
