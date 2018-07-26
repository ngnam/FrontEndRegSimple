module FeedbackDecoder exposing (requestCmd)

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
import Encoders


feedbackEndpoint : FeedbackType -> String
feedbackEndpoint feedbackType =
    case feedbackType of
        SnippetSuggest ( snippetId, _ ) ->
            "/snippet/" ++ snippetId ++ "/suggest/"

        SnippetVoteUp ( snippetId, _ ) ->
            "/snippet/" ++ snippetId ++ "/vote/up"

        SnippetVoteDown ( snippetId, _ ) ->
            "/snippet/" ++ snippetId ++ "/vote/down"



-- feedbackBody : FeedbackType


feedbackBody feedbackType =
    case feedbackType of
        SnippetSuggest ( snippetId, categoryIds ) ->
            Encoders.snippetSuggest categoryIds

        SnippetVoteUp ( snippetId, categoryId ) ->
            Encoders.snippetVote categoryId

        SnippetVoteDown ( snippetId, categoryId ) ->
            Encoders.snippetVote categoryId


request : Model -> FeedbackType -> Http.Request FeedbackResults
request model feedbackType =
    Http.request
        { method = "PUT"
        , headers = []
        , url = model.config.apiBaseUrl ++ "/feedback" ++ (feedbackEndpoint feedbackType) ++ model.location.search
        , body = Http.jsonBody <| feedbackBody feedbackType
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
