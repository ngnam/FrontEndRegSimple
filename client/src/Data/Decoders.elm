module Decoders exposing (user, snippetBookmarkMetadata, snippetBookmarks, session, decodeSessionFromJson, queryResultMatch)

import Json.Decode exposing (Decoder, Value, string, list, dict, andThen, succeed, oneOf, nullable, null, int, float, at, fail, map, map3, map4, field, decodeString, decodeValue)
import Json.Decode.Pipeline exposing (decode, required, optional)
import DataTypes exposing (User, Role(..), SnippetBookmarkMetadata, SnippetBookmarks, LocalStorageSession, QueryResultMatch, QueryResultMatchBody)
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
        |> required "countryId" string


nullableString : Decoder String
nullableString =
    oneOf [ string, null "" ]


queryResultMatch : Decoder QueryResultMatch
queryResultMatch =
    decode QueryResultMatch
        |> optional "score" float 0
        |> required "title" string
        |> required "type" nullableString
        |> required "country" string
        |> required "year" (nullable int)
        |> required "url" string
        |> required "id" string
        |> optional "body" (list matchBodyDecoder) []


matchBodyDecoder : Decoder QueryResultMatchBody
matchBodyDecoder =
    decode QueryResultMatchBody
        |> required "tags" (list string)
        |> required "text" string
        |> required "offset" int
        |> optional "summary" string ""
        |> required "url" string
        |> required "page" int
        |> required "id" string


snippetBookmarks : Decoder SnippetBookmarks
snippetBookmarks =
    let
        keyDecoder =
            map3 (,,) (field "snippetId" string) (field "categoryId" string) (field "countryId" string)

        valueDecoder =
            map4 SnippetBookmarkMetadata
                (at [ "createdAt" ] string)
                (at [ "snippetId" ] string)
                (at [ "categoryId" ] string)
                (at [ "countryId" ] string)
    in
        DictList.decodeArray2
            keyDecoder
            valueDecoder


session : Decoder LocalStorageSession
session =
    decode LocalStorageSession
        |> optional "user" (map Just user) Nothing
        |> optional "snippetBookmarks" snippetBookmarks DictList.empty


decodeSessionFromJson : Value -> Maybe LocalStorageSession
decodeSessionFromJson json =
    json
        |> decodeValue string
        |> Result.toMaybe
        |> Maybe.andThen (decodeString session >> Result.toMaybe)
