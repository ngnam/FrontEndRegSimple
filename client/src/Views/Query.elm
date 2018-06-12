module Views.Query exposing (..)

import Types exposing (..)
import Html exposing (Html, text, div, form, input, button, span)


view : Model -> Html Msg
view model =
    div [] [ text model.queryResults ]
