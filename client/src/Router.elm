module Router exposing (..)

import Html exposing (Html, div, text)
import Views.Home
import Views.Query
import Views.Login
import Views.About
import Types exposing (..)
import Navigation exposing (Location)
import Util exposing (parseParams)


parseLocation : Location -> Location
parseLocation location =
    { location
        | hash =
            String.split "?" location.hash
                |> List.head
                |> Maybe.withDefault ""
        , search =
            String.split "?" location.hash
                |> List.drop 1
                |> String.join "?"
                |> String.append "?"
    }


onUrlChange : Location -> Model -> Model
onUrlChange location model =
    { model
        | location = parseLocation location
        , search = parseParams (.search (parseLocation location))
    }


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
