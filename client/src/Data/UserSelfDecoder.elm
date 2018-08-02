module UserSelfDecoder exposing (requestCmd)

import Http
import RemoteData exposing (RemoteData(..))
import DataTypes exposing (User)
import Model exposing (Model, Msg(..))
import Json.Decode exposing (at)
import Decoders


request : String -> Http.Request User
request apiBaseUrl =
    Http.request
        { method = "GET"
        , headers = []
        , url = apiBaseUrl ++ "/user/self"
        , body = Http.emptyBody
        , expect = Http.expectJson <| at [ "data" ] Decoders.user
        , timeout = Nothing
        , withCredentials = True
        }


requestCmd : String -> Cmd Msg
requestCmd apiBaseUrl =
    request apiBaseUrl
        |> RemoteData.sendRequest
        |> Cmd.map UserSelfOnResponse
