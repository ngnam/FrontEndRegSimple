module Views.Login exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, button, input, form, text, section, div, h1, img)
import Html.Attributes exposing (type_, placeholder, value, class, src)
import Html.Events exposing (onSubmit, onInput)
import Util exposing (viewIf)
import RemoteData exposing (RemoteData(..))


view : Model -> Html Msg
view model =
    let
        showLoadingSpinner =
            case model.loginEmailResponse of
                Loading ->
                    True

                _ ->
                    False

        showCodeForm =
            case model.loginEmailResponse of
                Success _ ->
                    True

                _ ->
                    False
    in
        div []
            [ section [ class "mb4 flex justify-center" ]
                [ div [ class "flex justify-center flex-column w-25" ]
                    [ img [ class "w-100 mb2", src "/assets/logos/logo-with-text.png" ] []
                    , h1 [ class "mb2 metro-i" ] [ text "Regulation. Simplified." ]
                    ]
                ]
            , section [ class "flex justify-center" ]
                [ viewIf (not showCodeForm && not showLoadingSpinner) loginEmailForm
                , viewIf showLoadingSpinner loadingSpinner
                , viewIf (showCodeForm && not showLoadingSpinner) loginCodeForm
                ]
            ]


loadingSpinner : Html msg
loadingSpinner =
    div [ class "w15rem h3rem mv3 spinner" ] []


loginEmailForm : Html Msg
loginEmailForm =
    form [ class "w15rem flex flex-column", onSubmit LoginEmailFormOnSubmit ]
        [ input
            [ type_ "email"
            , placeholder "Email"
            , class "h3rem pv3 ph3 br-pill ba b--solid b--blue bg-white mb3 f6 placeholder--login"
            , onInput LoginEmailFormOnInput
            ]
            []
        , button [ class "h3rem ph3 white br-pill ba b--solid b--blue bg-blue mb3 f6 metro-b", value "submit" ] [ text "Sign In" ]
        ]


loginCodeForm : Html Msg
loginCodeForm =
    form [ class "w15rem flex flex-column", onSubmit LoginCodeFormOnSubmit ]
        [ input
            [ type_ "number"
            , placeholder "4 digit One Time Code"
            , class "h3rem pv3 ph3 br-pill ba b--solid b--blue bg-white mb3 f6 placeholder--login"
            , onInput LoginCodeFormOnInput
            ]
            []
        , button [ class "h3rem ph3 white br-pill ba b--solid b--blue bg-blue mb3 f6 metro-b", value "submit" ] [ text "Submit" ]
        ]
