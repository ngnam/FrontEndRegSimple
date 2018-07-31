module Encoders exposing (user, snippetVote, snippetSuggest, session)

import Json.Encode exposing (Value, object, string, list, null)
import DataTypes exposing (User, Role(..), SnippetFeedback, CategoryId, LocalStorageSession, SnippetBookmarks)
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



-- snippetBookmarks : SnippetBookmarks -> Value
-- snippetBookmarks snippetBookmarks =
--     list
--         [ ( "snippetBookmarks", DictList.map (string, tuple2Encoder snippetBookmarks )
--         ]


session : LocalStorageSession -> Value
session session =
    object
        [ ( "user", user session.user )

        -- , ( "snippetBookmarks", snippetBookmarks session.snippetBookmarks )
        ]


tuple2Encoder : (a -> Value) -> (b -> Value) -> ( a, b ) -> Value
tuple2Encoder enc1 enc2 ( val1, val2 ) =
    list [ enc1 val1, enc2 val2 ]
