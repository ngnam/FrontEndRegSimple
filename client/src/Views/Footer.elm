module Views.Footer exposing (..)

import Model exposing (Model, Msg)
import Html exposing (Html, footer, div, img, a, text)
import Html.Attributes exposing (src, class, href)


view : Model -> Html Msg
view model =
    footer [ class "h5 pt4" ]
        [ a [ href "/#/" ] [ img [ src "/assets/icons/twitter.svg" ] [] ]
        , div [] [ a [ class "f6", href "/#/about" ] [ text "About" ] ]
        ]
