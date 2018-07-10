module LoginDecoder exposing (requestLoginCodeCmd)

import Http
import RemoteData
import DataTypes exposing (User)
import Model exposing (Model, Msg(..))
import Json.Decode exposing (Decoder, string, at)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode


---- LOGIN FUNCTION ----


requestLoginCodeUrl : String
requestLoginCodeUrl =
    "/login/email"


emailEncoder : Model -> Encode.Value
emailEncoder model =
    Encode.object
        [ ( "email", Encode.string model.email )
        ]



-- POST register / login request


request : Model -> String -> Http.Request User
request model apiUrl =
    let
        body =
            model
                |> emailEncoder
                |> Http.jsonBody
    in
        Http.request
            { method = "POST"
            , headers = []
            , url = model.config.apiBaseUrl ++ apiUrl
            , body = body
            , expect = Http.expectJson (at [ "data" ] decoder)
            , timeout = Nothing
            , withCredentials = False
            }


requestLoginCodeCmd : Model -> Cmd Msg
requestLoginCodeCmd model =
    request model requestLoginCodeUrl
        |> RemoteData.sendRequest
        |> Cmd.map RequestLoginCodeCompleted


decoder : Decoder User
decoder =
    decode User
        |> required "userId" string
