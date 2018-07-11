module LoginEmailDecoder exposing (requestCmd)

import Http
import RemoteData
import DataTypes exposing (User)
import Model exposing (Model, Msg(..))
import Json.Decode exposing (Decoder, string, at)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode


encoder : Model -> Encode.Value
encoder model =
    Encode.object
        [ ( "email", Encode.string model.email )
        ]


request : Model -> Http.Request User
request model =
    let
        body =
            model
                |> encoder
                |> Http.jsonBody
    in
        Http.request
            { method = "POST"
            , headers = []
            , url = model.config.apiBaseUrl ++ "/login/email"
            , body = body
            , expect = Http.expectJson (at [ "data" ] decoder)
            , timeout = Nothing
            , withCredentials = True
            }


requestCmd : Model -> Cmd Msg
requestCmd model =
    request model
        |> RemoteData.sendRequest
        |> Cmd.map LoginEmailFormOnResponse


decoder : Decoder User
decoder =
    decode User
        |> required "id" string
        |> required "email" string
