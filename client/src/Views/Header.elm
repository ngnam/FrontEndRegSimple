module Views.Header exposing (..)

import Html exposing (Html, header, div, button, a, text)
import Html.Attributes exposing (class, href)
import Util exposing (viewIf)
import Model exposing (Model, Msg)


aboutPath : String
aboutPath =
    "/#/about"


view : Model -> Html Msg
view { location, isLoggedIn } =
    header [ class "flex ph5 h4 items-center justify-between f6" ]
        [ a [ href aboutPath, class "b ttu no-underline near-black" ]
            [ text "about" ]
        , viewIf (location.hash /= "#/login") (loginButton isLoggedIn)
        ]


loginButton : Bool -> Html Msg
loginButton isLoggedIn =
    a [ href "/#/login", class loggedInLinkClass ]
        [ text (ifLoggedIn isLoggedIn) ]


loggedInLinkClass : String
loggedInLinkClass =
    "b ttu no-underline near-black"


ifLoggedIn : Bool -> String
ifLoggedIn isLoggedIn =
    if isLoggedIn then
        "logout"
    else
        "login"
