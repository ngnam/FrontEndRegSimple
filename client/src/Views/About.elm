module Views.About exposing (..)

import Types exposing (..)
import Html exposing (Html, text, div, form, input, button, span)


view : Model -> Html Msg
view model =
    div [] [ text "About RegSimple" ]
