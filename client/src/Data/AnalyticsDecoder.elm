module AnalyticsDecoder exposing (requestCmd)

import Http
import Model exposing (Model, Msg(..))
import DataTypes
    exposing
        ( FeedbackType(..)
        , FeedbackResults
        )
import Json.Decode exposing (Decoder, list, int, float, string, at, oneOf, null, nullable, bool)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import RemoteData


request : Model -> FeedbackType -> Http.Request FeedbackResults
request model body =
    Http.request
        { method = "POST"
        , headers = [ Http.header "Content-Type" "application/json" ]
        , url = model.config.apiBaseUrl ++ "/feedback"
        , body = body
        , expect = Http.expectJson (at [ "data" ] decoder)
        , timeout = Nothing
        , withCredentials = True
        }


nullableString : Decoder String
nullableString =
    oneOf [ string, null "" ]


requestCmd : Model -> FeedbackType -> Cmd Msg
requestCmd model feedbackType =
    request model feedbackType
        |> RemoteData.sendRequest
        |> Cmd.map (FeedbackRequest feedbackType)


decoder : Decoder FeedbackResults
decoder =
    decode FeedbackResults
        |> required "id" string
