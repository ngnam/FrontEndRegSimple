module Router exposing (matchView)

import Html exposing (Html, div, text)
import Views.Home
import Views.Query
import Views.Login
import Views.About
import Views.Bookmarks
import Model exposing (Model, Msg)


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

        "#/bookmarks" ->
            Views.Bookmarks.view model

        _ ->
            div [] [ text "you're not supposed to be here, 404" ]
