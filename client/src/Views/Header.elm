module Views.Header exposing (..)

import Html exposing (Html, header, div, button, a, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Util exposing (viewIf)
import Model exposing (Model, Msg(..))
import Helpers.Session exposing (isLoggedIn)


aboutPath : String
aboutPath =
    "/#/about"


view : Model -> Html Msg
view { session, location } =
    header [ class "flex ph5 h4 items-center justify-between f6" ]
        [ if location.hash == "#/about" then
            a [ href "/#/", class "b ttu no-underline near-black" ]
                [ text "Home" ]
          else
            a [ href aboutPath, class "b ttu no-underline near-black" ]
                [ text "About" ]
        , viewIf (location.hash /= "#/login")
            (if isLoggedIn session then
                logoutButton
             else
                loginButton
            )
        ]


loginButton : Html Msg
loginButton =
    a [ href "/#/login", class loggedInLinkClass ]
        [ text "Login" ]


logoutButton : Html Msg
logoutButton =
    button [ class loggedInLinkClass, onClick LogoutClick ]
        [ text "Logout" ]


loggedInLinkClass : String
loggedInLinkClass =
    "b ttu no-underline near-black bg-transparent b--none"
