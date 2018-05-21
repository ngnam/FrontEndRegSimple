module Views.Home exposing (..)

import Types exposing (..)
import Html exposing (Html, text, div, h1, img)


view : Model -> Html msg
view model =
    div []
        [ h1 [] [ text "home" ]
        ]
