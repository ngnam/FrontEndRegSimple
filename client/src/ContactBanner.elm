module ContactBanner exposing (..)

import Html exposing (Html, header, div, button, a, text)
import Html.Attributes exposing (class, href)


view : Html msg
view =
    div [ class "flex ph5 h2 items-center justify-center bg-blue white f6" ]
        [ text "Since we're only in our Alpha we would love to hear any feedback/suggestions you have:", emailLink ]


emailLink : Html msg
emailLink =
    a [ href "mailto:info@regsimple.io?Subject=Hello%20Hello", class "gray pl2" ]
        [ text "info@regsimple.io" ]
