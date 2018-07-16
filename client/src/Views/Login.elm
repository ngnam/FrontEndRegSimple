module Views.Login exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, button, input, form, text, section, div, h1, img, span)
import Html.Attributes exposing (type_, placeholder, value, class, src, required, classList, pattern, maxlength, minlength)
import Html.Events exposing (onSubmit, onInput)
import Util exposing (viewIf)
import RemoteData exposing (RemoteData(..), WebData)
import DataTypes exposing (User)


view : Model -> Html Msg
view { loginEmailResponse, loginCodeResponse } =
    let
        showLoadingSpinner =
            case loginEmailResponse of
                Loading ->
                    True

                _ ->
                    False

        showCodeForm =
            case loginEmailResponse of
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
            , section [ class "flex justify-center relative" ]
                [ viewIf (not showCodeForm) (loginEmailForm loginEmailResponse)
                , viewIf showCodeForm (loginCodeForm loginCodeResponse)
                ]
            ]


loadingSpinner : Html msg
loadingSpinner =
    div [ class "w15rem h3rem mv3 spinner" ] []


loginEmailForm : WebData User -> Html Msg
loginEmailForm loginEmailResponse =
    loginForm
        { onInputMsg = LoginEmailFormOnInput
        , onSubmitMsg = LoginEmailFormOnSubmit
        , inputPlaceholder = "Email"
        , inputType = "email"
        , buttonText = "Sign In"
        , response = loginEmailResponse
        , inputPattern = "*"
        , inputMaxlength = 99999
        , inputMinlength = 0
        }


loginCodeForm : WebData User -> Html Msg
loginCodeForm loginCodeResponse =
    loginForm
        { onInputMsg = LoginCodeFormOnInput
        , onSubmitMsg = LoginCodeFormOnSubmit
        , inputPlaceholder = "4 digit One Time Code"
        , inputType = "text"
        , buttonText = "Submit"
        , response = loginCodeResponse
        , inputPattern = "\\d*"
        , inputMaxlength = 4
        , inputMinlength = 4
        }


type alias LoginFormModel =
    { onInputMsg : String -> Msg
    , onSubmitMsg : Msg
    , inputType : String
    , inputPlaceholder : String
    , buttonText : String
    , response : WebData User
    , inputPattern : String
    , inputMaxlength : Int
    , inputMinlength : Int
    }


loginForm : LoginFormModel -> Html Msg
loginForm { onInputMsg, onSubmitMsg, inputType, inputPlaceholder, inputPattern, inputMaxlength, inputMinlength, buttonText, response } =
    let
        ( isFailure, isLoading ) =
            case response of
                Failure _ ->
                    ( True, False )

                Loading ->
                    ( False, True )

                _ ->
                    ( False, False )
    in
        form [ class "w15rem flex flex-column", onSubmit onSubmitMsg ]
            [ input
                [ type_ inputType
                , pattern inputPattern
                , maxlength inputMaxlength
                , minlength inputMinlength
                , placeholder inputPlaceholder
                , classList
                    [ ( "h3rem pv3 ph3 br-pill ba b--solid bg-white mb3 f6 placeholder--login", True )
                    , ( "b--blue", not isFailure )
                    , ( "b--red", isFailure )
                    ]
                , onInput onInputMsg
                , required True
                ]
                []
            , button
                [ class "h3rem ph3 white br-pill ba b--solid b--blue bg-blue mb4 f6 metro-b relative"
                , value "submit"
                ]
                [ if isLoading then
                    span [ class "w15rem h3rem mv3 spinner" ] []
                  else
                    text buttonText
                ]
            , viewIf isFailure
                (div
                    [ class "absolute tc left-0 right-0 bottom-0" ]
                    [ text "That doesn't look right, please try again." ]
                )
            ]
