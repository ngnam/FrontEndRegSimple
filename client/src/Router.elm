module Router exposing (..)

import Html exposing (Html, div, text)
import Views.Home
import Views.Query
import Views.Login
import Views.About
import Types exposing (..)


matchView : Model -> Html Msg
matchView model =
    case model.location.hash of
        "#/" ->
            Views.Home.view model

        "#/query" ->
            Views.Query.view model

        "#/login" ->
            Views.Login.view model

        "#/about" ->
            Views.About.view model

        _ ->
            div [] [ text "you're not supposed to be here, 404" ]
