module QueryDecoder exposing (requestCmd)

import Http
import Model exposing (Model, Msg(..))
import DataTypes exposing (QueryResults, QueryResultsMatch, QueryResultsMatchBody)
import Json.Decode exposing (Decoder, list, int, float, string, at, oneOf, null)
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


nullableInt : Decoder Int
nullableInt =
    oneOf [ int, null 0 ]


requestCmd : Model -> Cmd Msg
requestCmd model =
    Http.send FetchQueryResults (request model)


matchBodyDecoder : Decoder QueryResultsMatchBody
matchBodyDecoder =
    decode QueryResultsMatchBody
        |> required "tags" (list string)
        |> required "text" string
        |> required "offset" int


matchDecoder : Decoder QueryResultsMatch
matchDecoder =
    decode QueryResultsMatch
        |> required "score" float
        |> required "title" string
        |> required "type" nullableString
        |> required "country" string
        |> required "year" nullableInt
        |> required "url" string
        |> required "id" string
        |> required "body" (list matchBodyDecoder)


decoder : Decoder QueryResults
decoder =
    decode QueryResults
        |> required "n_matches" int
        |> required "total_matches" int
        |> required "max_score" float
        |> required "matches" (list matchDecoder)
