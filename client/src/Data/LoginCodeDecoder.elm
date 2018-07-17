module LoginCodeDecoder exposing (requestCmd)

import Http
import RemoteData exposing (RemoteData(..))
import DataTypes exposing (User)
import Model exposing (Model, Msg(..))
import Json.Decode exposing (Decoder, string, at)
import Json.Encode as Encode
import Decoders


encoder : Model -> Encode.Value
encoder model =
    Encode.object
        [ ( "code", Encode.string model.loginCode )
        , ( "userId"
          , Encode.string
                (case model.loginEmailResponse of
                    Success user ->
                        user.id

                    _ ->
                        ""
                )
          )
        ]



-- POST register / login request


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
            , url = model.config.apiBaseUrl ++ "/login/code"
            , body = body
            , expect = Http.expectJson (at [ "data" ] Decoders.user)
            , timeout = Nothing
            , withCredentials = True
            }


requestCmd : Model -> Cmd Msg
requestCmd model =
    request model
        |> RemoteData.sendRequest
        |> Cmd.map LoginCodeFormOnResponse
