module Views.Login exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, button, input, form, text, div, h1, img)
import Html.Attributes exposing (type_, placeholder, value)
import Html.Events exposing (onSubmit, onInput)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "login" ]
        , loginForm
        ]


loginForm : Html Msg
loginForm =
    form [ onSubmit SubmitLoginEmailForm ]
        [ input [ type_ "email", placeholder "Email address", onInput LoginEmailFormOnInput ] []
        , button [ value "submit" ] [ text "Submit" ]
        ]
