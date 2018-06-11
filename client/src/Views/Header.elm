module Views.Header exposing (..)

import Html exposing (Html, header, div, button, a, text)
import Html.Attributes exposing (class, href)
import Types exposing (..)


aboutPath : String
aboutPath =
    "/#/about"


view : Model -> Html Msg
view model =
    header [ class "flex ph5 pv4 justify-between f6" ]
        [ a [ href aboutPath, class "b ttu no-underline near-black" ]
            [ text "about" ]
        , viewLoginButton model
        ]


viewLoginButton : Model -> Html Msg
viewLoginButton { location, isLoggedIn } =
    case location.pathname of
        "/#/login" ->
            div [] []

        _ ->
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
