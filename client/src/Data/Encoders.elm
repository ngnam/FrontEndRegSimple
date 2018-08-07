module Encoders exposing (user, snippetVote, snippetSuggest, session, detailedSnippetBookmarks)

import Json.Encode exposing (Value, object, string, list, null)
import DataTypes exposing (User, Role(..), SnippetFeedback, LocalStorageSession, SnippetBookmarks, SnippetBookmarkMetadata, CategoryId)
import DictList


user : Maybe User -> Value
user maybeUser =
    case maybeUser of
        Just user ->
            object
                [ ( "email", string user.email )
                , ( "id", string user.id )
                , ( "role", roleEncoder user.role )
                ]

        Nothing ->
            null


roleEncoder : Role -> Value
roleEncoder role =
    string
        (case role of
            RoleUser ->
                "ROLE_USER"

            RoleEditor ->
                "ROLE_EDITOR"

            RoleAdmin ->
                "ROLE_ADMIN"
        )


snippetSuggest : List CategoryId -> Value
snippetSuggest categoryIds =
    object
        [ ( "suggestedCategories", list (List.map string categoryIds) )
        ]


snippetVote : CategoryId -> Value
snippetVote categoryId =
    object
        [ ( "categoryId", string categoryId )
        ]


snippetBookmarks : SnippetBookmarks -> Value
snippetBookmarks snippetBookmarks =
    list
        (List.map (\( _, bookmarkValue ) -> snippetBookmarkMetadata bookmarkValue)
            (DictList.toList
                snippetBookmarks
            )
        )


detailedSnippetBookmarks : SnippetBookmarks -> Value
detailedSnippetBookmarks snippetBookmarks =
    list
        (List.map (\( _, bookmarkValue ) -> string bookmarkValue.snippetId)
            (DictList.toList
                snippetBookmarks
            )
        )


snippetBookmarkMetadata : SnippetBookmarkMetadata -> Value
snippetBookmarkMetadata snippetBookmark =
    object
        [ ( "createdAt", string snippetBookmark.createdAt )
        , ( "snippetId", string snippetBookmark.snippetId )
        , ( "categoryId", string snippetBookmark.categoryId )
        , ( "countryId", string snippetBookmark.countryId )
        ]


session : LocalStorageSession -> Value
session session =
    object
        [ ( "user", user session.user )
        , ( "snippetBookmarks", snippetBookmarks session.snippetBookmarks )
        ]
