module Encoders exposing (user, snippetSuggest, snippetVote)

import Json.Encode exposing (Value, object, string, list)
import DataTypes exposing (User, Role(..), SnippetFeedback, CategoryId)


user : User -> Value
user { email, id, role } =
    object
        [ ( "email", string email )
        , ( "id", string id )
        , ( "role", roleEncoder role )
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
