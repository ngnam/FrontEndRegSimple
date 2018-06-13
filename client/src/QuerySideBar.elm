module QuerySideBar exposing (..)

import Html exposing (Html, nav, div, a, button, img, text)
import Html.Attributes exposing (class, src, href)
import Types exposing (..)


divider : Html msg
divider =
    div [ class "w-05 fl h2 flex justify-center" ] [ div [ class "br b--light-gray w0 h2 mh0" ] [] ]


inputClass : String
inputClass =
    "w-100 h2 fl pv2 ph3 br-pill ba b--solid b--blue"


view : Model -> Html Msg
view model =
    nav [ class "w3 h-100 bg-dark-blue fixed" ]
        [ a [ href "/#/" ] [ img [ class "w2", src "assets/logos/logo_icon.svg" ] [] ] ]
