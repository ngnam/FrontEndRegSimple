module Decoders exposing (user)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)
import DataTypes exposing (User)


user : Decoder User
user =
    decode User
        |> required "id" string
        |> required "email" string
