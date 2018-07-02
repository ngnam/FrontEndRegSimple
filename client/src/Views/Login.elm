module Views.Login exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, button, input, form, text, section, div, h1, img)
import Html.Attributes exposing (type_, placeholder, value, class, src)
import Html.Events exposing (onSubmit, onInput)


view : Model -> Html Msg
view model =
    div []
        [ section [ class "mb4 flex justify-center" ]
            [ div [ class "flex justify-center flex-column w-25" ]
                [ img [ class "w-100 mb2", src "/assets/logos/logo_icon+text_new.png" ] []
                , h1 [ class "mb2 metro-i" ] [ text "Regulation. Simplified." ]
                ]
            ]
        , section [ class "flex justify-center" ] [ loginForm ]
        ]


loginForm : Html Msg
loginForm =
    form [ class "w-20 flex flex-column", onSubmit SubmitLoginEmailForm ]
        [ input
            [ type_ "email"
            , placeholder "Email"
            , class "h2 pv3 ph3 br-pill ba b--solid b--blue bg-white mb3 f6 placeholder--login"
            , onInput LoginEmailFormOnInput
            ]
            []
        , button [ class "h2 ph3 white br-pill ba b--solid b--blue bg-blue mb3 f6", value "submit" ] [ text "Sign In" ]
        ]
