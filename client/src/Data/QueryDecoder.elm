module QueryDecoder exposing (requestCmd)

import Http
import Model exposing (Model, Msg(..))
import DataTypes exposing (QueryResults)
import Json.Decode exposing (Decoder, string, at)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


request : Model -> Http.Request QueryResults
request model =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Content-Type" "application/json" ]
        , url = model.config.apiBaseUrl ++ "/query" ++ model.location.search
        , body = Http.emptyBody
        , expect = Http.expectJson (decoder)
        , timeout = Nothing
        , withCredentials = False
        }


requestCmd : Model -> Cmd Msg
requestCmd model =
    Http.send FetchQueryResults (request model)


decoder : Decoder QueryResults
decoder =
    decode QueryResults
        |> required "data" string
