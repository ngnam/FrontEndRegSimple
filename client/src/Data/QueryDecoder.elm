module QueryDecoder exposing (requestCmd)

import Http
import Model exposing (Model, Msg(..))
import DataTypes exposing (QueryResults, QueryResult, QueryResultMatch, QueryResultMatchBody, CategoryCountry, CategoryId, CountryId)
import Json.Decode exposing (Decoder, andThen, list, int, float, string, at, oneOf, null, nullable, decodeString, field, map2)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import RemoteData
import DictList


request : Model -> Http.Request QueryResults
request model =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Content-Type" "application/json" ]
        , url = model.config.apiBaseUrl ++ "/query" ++ model.location.search
        , body = Http.emptyBody
        , expect = Http.expectJson (at [ "data" ] decoder)
        , timeout = Nothing
        , withCredentials = True
        }


nullableString : Decoder String
nullableString =
    oneOf [ string, null "" ]


requestCmd : Model -> Cmd Msg
requestCmd model =
    request model
        |> RemoteData.sendRequest
        |> Cmd.map FetchQueryResults


matchBodyDecoder : Decoder QueryResultMatchBody
matchBodyDecoder =
    decode QueryResultMatchBody
        |> required "tags" (list string)
        |> required "text" string
        |> required "offset" int
        |> required "summary" string
        |> required "url" string
        |> required "page" int
        |> required "id" string


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
    let
        keyDecoder =
            map2 (,) (field "category" string) (field "country" string)

        valueDecoder =
            field "result" queryResultDecoder
    in
        DictList.decodeArray2
            keyDecoder
            valueDecoder
