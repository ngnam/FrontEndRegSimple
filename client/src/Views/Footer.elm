module Views.Footer exposing (..)

import Html exposing (Html, footer, div, img, a, text)
import Html.Attributes exposing (src, class, href)
import Types exposing (..)


view : Model -> Html Msg
view model =
    footer []
        [ a [ href "/" ] [ img [ src "/assets/icons/twitter.svg" ] [] ]
        , div [] [ a [ class "f6", href "/" ] [ text "Terms of Use" ] ]
        ]
