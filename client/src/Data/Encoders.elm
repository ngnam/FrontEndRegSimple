module Encoders exposing (user)

import Json.Encode exposing (Value, object, string)
import DataTypes exposing (User)


user : User -> Value
user { email, id } =
    object
        [ ( "email", string email )
        , ( "id", string id )
        ]
