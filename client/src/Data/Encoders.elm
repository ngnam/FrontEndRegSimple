module Encoders exposing (user, snippetSuggest, snippetVote)

import Json.Encode exposing (Value, object, string, list)
import DataTypes exposing (User, Role(..), SnippetFeedback, CategoryId)


user : User -> Value
user user =
    object
        [ ( "email", string user.email )
        , ( "id", string user.id )
        , ( "role", roleEncoder user.role )
        ]


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
