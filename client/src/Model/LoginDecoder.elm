module LoginDecoder exposing (requestLoginCodeCmd)

import Http
import Types exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)


---- LOGIN FUNCTION ----


requestLoginCodeUrl : String
requestLoginCodeUrl =
    "login/email"


emailEncoder : Model -> Encode.Value
emailEncoder model =
    Encode.object
        [ ( "user", Encode.string model.email )
        ]



-- POST register / login request


requestLoginCode : Model -> String -> Http.Request String
requestLoginCode model apiUrl =
    let
        body =
            model
                |> emailEncoder
                |> Http.jsonBody
    in
        Http.post (model.config.apiBaseUrl ++ apiUrl) body responseDecoder


requestLoginCodeCmd : Model -> Cmd Msg
requestLoginCodeCmd model =
    Http.send requestLoginCodeCompleted (requestLoginCode model requestLoginCodeUrl)


responseDecoder : Decoder String
responseDecoder =
    Decode.string


requestLoginCodeCompleted : Result Http.Error String -> Msg
requestLoginCodeCompleted result =
    case result of
        Ok _ ->
            RequestLoginCodeCompleted

        Err _ ->
            RequestLoginCodeCompleted
