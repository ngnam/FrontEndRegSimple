module Encoders exposing (user, snippetFeedback)

import Json.Encode exposing (Value, object, string, list)
import DataTypes exposing (User, Role(..), SnippetFeedback)


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


snippetFeedback : SnippetFeedback -> Value
snippetFeedback model =
    object
        [ ( "suggestedCategories", list (List.map string model.categoryIds) )
        ]
