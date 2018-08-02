module UserEditsDecoder exposing (requestCmd)

import Http
import RemoteData
import DataTypes exposing (User, UserType)
import Model exposing (Model, Msg(..))
import Json.Decode exposing (Decoder, string, at)
import Json.Encode as Encode
import Decoders


type alias UserEdits =
    { userType : UserType
    }


encoder : UserEdits -> Encode.Value
encoder { userType } =
    Encode.object
        [ ( "userType", Encode.string userType ) ]


request : String -> UserEdits -> Http.Request User
request apiBaseUrl userEdits =
    Http.request
        { method = "POST"
        , headers = []
        , url = apiBaseUrl ++ "/user"
        , body = Http.jsonBody <| encoder userEdits
        , expect = Http.expectJson (at [ "data" ] Decoders.user)
        , timeout = Nothing
        , withCredentials = True
        }


requestCmd : String -> UserEdits -> Cmd Msg
requestCmd apiBaseUrl userEdits =
    request apiBaseUrl userEdits
        |> RemoteData.sendRequest
        |> Cmd.map (\_ -> NoOp)
