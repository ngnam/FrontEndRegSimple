module AnalyticsDecoder exposing (requestCmd)

import Http
import Model exposing (Model, Msg(..))
import DataTypes exposing (..)
import Json.Encode as Encode


request : Model -> AnalyticsEvent -> Http.Request ()
request model data =
    Http.request
        { method = "POST"
        , headers = []
        , url = model.config.apiBaseUrl ++ "/analytics"
        , body = Http.jsonBody (encoder data)
        , expect = Http.expectStringResponse (\_ -> Ok ())
        , timeout = Nothing
        , withCredentials = True
        }


requestCmd : Model -> AnalyticsEvent -> Cmd Msg
requestCmd model data =
    request model data
        |> Http.send (\_ -> NoOp)


encoder : AnalyticsEvent -> Encode.Value
encoder { eventName, params } =
    Encode.object
        [ ( "eventName", Encode.string (eventNameEncoder eventName) )
        , ( "params", Encode.string params )
        ]


eventNameEncoder : AnalyticsEventName -> String
eventNameEncoder =
    (\event ->
        case event of
            Event1 ->
                "Event1"

            Event2 ->
                "Event2"
    )
