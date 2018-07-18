module Decoders exposing (user)

import Json.Decode exposing (Decoder, string, andThen, succeed, fail)
import Json.Decode.Pipeline exposing (decode, required)
import DataTypes exposing (User, Role(..))
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
