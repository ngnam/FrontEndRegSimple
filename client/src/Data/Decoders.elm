module Decoders exposing (user)

import Json.Decode exposing (Decoder, string, andThen, succeed, fail)
import Json.Decode.Pipeline exposing (decode, required)
import DataTypes exposing (User, Role(..))


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
                case str of
                    "ROLE_USER" ->
                        succeed RoleUser

                    "ROLE_EDITOR" ->
                        succeed RoleEditor

                    "ROLE_ADMIN" ->
                        succeed RoleAdmin

                    other ->
                        fail <| "Unexpected role: " ++ other
            )
