module Views.Footer exposing (..)

import Html exposing (Html, footer, div, img, a, text)
import Html.Attributes exposing (src, class)
import Types exposing (..)


view : Model -> Html Msg
view model =
    footer []
        [ img [ src "/assets/icons/twitter_icn.svg" ] []
        , div [] [ a [ class "f6" ] [ text "Terms of Use" ] ]
        ]
