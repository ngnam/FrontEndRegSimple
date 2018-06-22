module QuerySideBar exposing (..)

import Html exposing (Html, nav, div, a, button, img, text)
import Html.Attributes exposing (class, src, href)
import Model exposing (Model, Msg)


divider : Html msg
divider =
    div [ class "w-05 fl h2 flex justify-center" ] [ div [ class "br b--light-gray w0 h2 mh0" ] [] ]


view : Model -> Html Msg
view model =
    nav [ class "w3 min-h-100 bg-dark-blue pt3" ]
        [ a [ href "/#/" ] [ img [ class "w2", src "assets/logos/logo-icon.svg" ] [] ] ]
