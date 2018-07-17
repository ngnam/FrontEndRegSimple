module Encoders exposing (user)

import Json.Encode exposing (Value, object, string)
import DataTypes exposing (User, Role(..))


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
