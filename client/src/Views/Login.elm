module Views.Login exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, main_, button, input, form, text, section, div, h1, img, span)
import Html.Attributes exposing (type_, placeholder, value, class, src, required, classList, pattern, maxlength, minlength)
import Html.Events exposing (onSubmit, onInput)
import Util exposing (viewIf)
import RemoteData exposing (RemoteData(..), WebData)
import DataTypes exposing (User)


view : Model -> Html Msg
view { user, loginEmail, loginCode, loginEmailResponse, loginCodeResponse } =
    main_ [ class "main--login" ]
        [ section [ class "h-50 flex justify-center" ]
            [ div [ class "flex justify-center flex-column w-25" ]
                [ img [ class "w-100 mb2", src "/assets/logos/logo-with-text.png" ] []
                , h1 [ class "mb2 metro-i" ] [ text "Regulation. Simplified." ]
                ]
            ]
        , section [ class "flex justify-center relative" ]
            [ case ( user, loginEmailResponse ) of
                ( Just user, _ ) ->
                    logoutForm user

                ( _, Success _ ) ->
                    loginCodeForm ( loginCode, loginCodeResponse )

                ( _, _ ) ->
                    loginEmailForm ( loginEmail, loginEmailResponse )
            ]
        ]


loadingSpinner : Html msg
loadingSpinner =
    div [ class "w15rem h3rem mv3 spinner" ] []


logoutForm : User -> Html Msg
logoutForm { email } =
    loginForm
        { onInputMsg = (\_ -> NoOp)
        , onSubmitMsg = LogoutClick
        , replaceInputWith = Just ("You're already logged in as " ++ email ++ ", want to log out?")
        , inputPlaceholder = ""
        , inputType = ""
        , buttonText = "Log out"
        , response = NotAsked
        , inputValue = ""
        , inputPattern = "*"
        , inputMaxlength = 0
        , inputMinlength = 0
        , errorText = "We had some trouble on our end, please contact support"
        }


loginEmailForm : ( String, WebData User ) -> Html Msg
loginEmailForm ( loginEmail, loginEmailResponse ) =
    loginForm
        { onInputMsg = LoginEmailFormOnInput
        , onSubmitMsg = LoginEmailFormOnSubmit
        , replaceInputWith = Nothing
        , inputPlaceholder = "Email"
        , inputType = "email"
        , buttonText = "Sign In"
        , response = loginEmailResponse
        , inputValue = loginEmail
        , inputPattern = "*"
        , inputMaxlength = 99999
        , inputMinlength = 0
        , errorText = "We had some trouble on our end, please contact support"
        }


loginCodeForm : ( String, WebData User ) -> Html Msg
loginCodeForm ( loginCode, loginCodeResponse ) =
    loginForm
        { onInputMsg = LoginCodeFormOnInput
        , onSubmitMsg = LoginCodeFormOnSubmit
        , replaceInputWith = Nothing
        , inputPlaceholder = "4 digit One Time Code"
        , inputType = "text"
        , buttonText = "Submit"
        , response = loginCodeResponse
        , inputValue = loginCode
        , inputPattern = "\\d*"
        , inputMaxlength = 4
        , inputMinlength = 4
        , errorText = "That code doesn't seem to be right or has expired, please try again."
        }


type alias LoginFormModel =
    { onInputMsg : String -> Msg
    , onSubmitMsg : Msg
    , replaceInputWith : Maybe String
    , inputType : String
    , inputPlaceholder : String
    , buttonText : String
    , response : WebData User
    , inputValue : String
    , inputPattern : String
    , inputMaxlength : Int
    , inputMinlength : Int
    , errorText : String
    }


loginForm : LoginFormModel -> Html Msg
loginForm { onInputMsg, onSubmitMsg, inputType, replaceInputWith, inputValue, inputPlaceholder, inputPattern, inputMaxlength, inputMinlength, buttonText, response, errorText } =
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
            [ case replaceInputWith of
                Nothing ->
                    input
                        [ type_ inputType
                        , pattern inputPattern
                        , maxlength inputMaxlength
                        , minlength inputMinlength
                        , placeholder inputPlaceholder
                        , value inputValue
                        , classList
                            [ ( "h3rem pv3 ph3 br-pill ba b--solid bg-white mb3 f6 placeholder--login", True )
                            , ( "b--blue", not isFailure )
                            , ( "b--red", isFailure )
                            ]
                        , onInput onInputMsg
                        , required True
                        ]
                        []

                Just replacementText ->
                    text replacementText
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
                    [ text errorText ]
                )
            ]
