module Router exposing (..)

import Html exposing (Html, div, text)
import Views.Home exposing (..)
import Types exposing (..)
import Views.Login


matchView : Model -> Html Msg
matchView model =
    case model.location.pathname of
        "/" ->
            Views.Home.view model

        "/login" ->
            Views.Login.view model

        _ ->
            div [] [ text "you're not supposed to be here, 404" ]
