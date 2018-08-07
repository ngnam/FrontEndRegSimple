module DetailedBookmarksDecoder exposing (requestCmd)

import Http
import RemoteData exposing (RemoteData(..))
import DataTypes exposing (QueryResultMatch, DetailedSnippetBookmarks)
import Model exposing (Model, Msg(..))
import Json.Decode exposing (at, list)
import DictList
import Decoders


request : Model -> Http.Request (List QueryResultMatch)
request model =
    let
        { snippetBookmarks } =
            model

        snippetIdQueryString =
            snippetBookmarks
                |> DictList.values
                |> List.map (\snippetBookmarkValue -> snippetBookmarkValue.snippetId)
                |> List.foldl (\id accum -> accum ++ "blocks[]=" ++ id ++ "&") ""
    in
        Http.request
            { method = "GET"
            , headers = []
            , url = model.config.apiBaseUrl ++ "/bookmark/detail?" ++ snippetIdQueryString
            , body = Http.emptyBody
            , expect = Http.expectJson (at [ "data" ] (list Decoders.queryResultMatch))
            , timeout = Nothing
            , withCredentials = True
            }


requestCmd : Model -> Cmd Msg
requestCmd model =
    request model
        |> RemoteData.sendRequest
        |> Cmd.map
            (\detailedSnippetBookmarksResponse ->
                case detailedSnippetBookmarksResponse of
                    Success detailedSnippetBookmarksResponse ->
                        SetDetailedSnippetBookmarks detailedSnippetBookmarksResponse

                    _ ->
                        NoOp
            )
