module Update exposing (..)

import Types exposing (..)
import LoginDecoder exposing (requestLoginCodeCmd)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitLoginEmailForm ->
            ( model, requestLoginCodeCmd model )

        LoginEmailFormOnInput email ->
            ( { model | email = email }, Cmd.none )

        _ ->
            ( model, Cmd.none )
