module Decoders exposing (user, snippetBookmarkMetadata, snippetBookmarks, session)

import Json.Decode exposing (Decoder, string, list, dict, andThen, succeed, at, fail, map, map2, map3, field)
import Json.Decode.Pipeline exposing (decode, required, optional)
import DataTypes exposing (User, Role(..), SnippetBookmarkMetadata, SnippetBookmarks, LocalStorageSession)
import Helpers.Session exposing (roles)
import DictList


user : Decoder User
user =
    decode User
        |> required "id" string
        |> required "email" string
        |> required "role" role


role : Decoder Role
role =
    string
        |> andThen
            (\str ->
                case DictList.get str roles of
                    Just role ->
                        succeed role

                    Nothing ->
                        fail <| "Unexpected role: " ++ str
            )


snippetBookmarkMetadata : Decoder SnippetBookmarkMetadata
snippetBookmarkMetadata =
    decode SnippetBookmarkMetadata
        |> required "createdAt" string
        |> required "snippetId" string
        |> required "categoryId" string


snippetBookmarks : Decoder SnippetBookmarks
snippetBookmarks =
    let
        keyDecoder =
            map2 (,) (field "snippetId" string) (field "categoryId" string)

        valueDecoder =
            map3 SnippetBookmarkMetadata
                (at [ "createdAt" ] string)
                (at [ "snippetId" ] string)
                (at [ "categoryId" ] string)
    in
        DictList.decodeArray2
            keyDecoder
            valueDecoder


session : Decoder LocalStorageSession
session =
    decode LocalStorageSession
        |> optional "user" (map Just user) Nothing
        |> optional "snippetBookmarks" snippetBookmarks DictList.empty
