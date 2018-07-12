module LogoutDecoder exposing (requestCmd)

import Http
import RemoteData exposing (RemoteData(..))
import DataTypes exposing (User)
import Model exposing (Model, Msg(..))


request : Model -> Http.Request String
request model =
    Http.request
        { method = "POST"
        , headers = []
        , url = model.config.apiBaseUrl ++ "/logout"
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = True
        }


requestCmd : Model -> Cmd Msg
requestCmd model =
    request model
        |> RemoteData.sendRequest
        |> Cmd.map LogoutOnResponse
