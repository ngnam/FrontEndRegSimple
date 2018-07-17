port module Ports exposing (copy, onSessionChange, storeSession)

import Json.Encode exposing (Value)


port copy : String -> Cmd msg


port storeSession : Maybe String -> Cmd msg


port onSessionChange : (Value -> msg) -> Sub msg
