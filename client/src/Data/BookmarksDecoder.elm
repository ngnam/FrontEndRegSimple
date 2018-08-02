module BookmarksDecoder exposing (postRequestCmd, deleteRequestCmd, getRequestCmd)

import Http
import RemoteData exposing (RemoteData(..))
import DataTypes exposing (SnippetBookmarkKey, SnippetBookmarkMetadata, SnippetBookmarks)
import Model exposing (Model, Msg(..))
import Json.Encode as Encode
import Json.Decode exposing (at)
import Decoders
import DictList


encoder : SnippetBookmarkKey -> Encode.Value
encoder ( snippetId, categoryId ) =
    Encode.object
        [ ( "snippetId", Encode.string snippetId )
        , ( "categoryId", Encode.string categoryId )
        ]


request : Model -> SnippetBookmarkKey -> String -> Http.Request SnippetBookmarkMetadata
request model snippetBookmarkKey requestMethod =
    let
        body =
            snippetBookmarkKey
                |> encoder
                |> Http.jsonBody
    in
        Http.request
            { method = requestMethod
            , headers = []
            , url = model.config.apiBaseUrl ++ "/bookmarks"
            , body = body
            , expect = Http.expectJson (at [ "data" ] Decoders.snippetBookmarkMetadata)
            , timeout = Nothing
            , withCredentials = True
            }


postRequestCmd : Model -> SnippetBookmarkKey -> Cmd Msg
postRequestCmd model snippetBookmarkKey =
    request model snippetBookmarkKey "POST"
        |> RemoteData.sendRequest
        |> Cmd.map
            (\snippetBookmarksResponse ->
                case snippetBookmarksResponse of
                    Success snippetBookmarksResponse ->
                        SnippetBookmarkAdd snippetBookmarkKey snippetBookmarksResponse

                    _ ->
                        NoOp
            )


deleteRequestCmd : Model -> SnippetBookmarkKey -> Cmd Msg
deleteRequestCmd model snippetBookmarkKey =
    request model snippetBookmarkKey "DELETE"
        |> RemoteData.sendRequest
        |> Cmd.map
            (\snippetBookmarksResponse ->
                case snippetBookmarksResponse of
                    Success snippetBookmarksResponse ->
                        SnippetBookmarkRemove snippetBookmarkKey

                    _ ->
                        NoOp
            )


getRequestCmd : Model -> Cmd Msg
getRequestCmd model =
    getRequest model
        |> RemoteData.sendRequest
        |> Cmd.map
            (\snippetBookmarksResponse ->
                case snippetBookmarksResponse of
                    Success snippetBookmarksResponse ->
                        SnippetBookmarksHydrate snippetBookmarksResponse

                    _ ->
                        NoOp
            )


getRequest : Model -> Http.Request SnippetBookmarks
getRequest model =
    Http.request
        { method = "GET"
        , headers = []
        , url = model.config.apiBaseUrl ++ "/bookmarks"
        , body = Http.emptyBody
        , expect = Http.expectJson (at [ "data" ] Decoders.snippetBookmarks)
        , timeout = Nothing
        , withCredentials = True
        }
