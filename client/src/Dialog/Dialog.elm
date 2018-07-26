module Dialog.Dialog exposing (dialog)

import Html exposing (Html, Attribute, div, text)
import Html.Events exposing (onClick, defaultOptions, onWithOptions)
import Html.Attributes exposing (id, class, tabindex)
import Html.Attributes.Aria exposing (role, ariaHidden, ariaExpanded)
import Util exposing (boolStr, viewIf)
import Json.Decode as Json
import Model exposing (Model, Msg)


dialog : Html Msg -> Msg -> String -> Bool -> Html Msg
dialog dialogInner closeMsg dialogId menuOpen =
    let
        onKeyDown =
            let
                options =
                    { defaultOptions | preventDefault = True }

                filterKey code =
                    if code == 27 then
                        Json.succeed closeMsg
                    else
                        Json.fail "ignored input"

                decoder =
                    Html.Events.keyCode
                        |> Json.andThen filterKey
            in
                onWithOptions "keydown" options decoder
    in
        viewIf menuOpen <|
            div
                [ class "fixed absolute--fill flex justify-center items-center z-1"
                , ariaExpanded (boolStr menuOpen)
                ]
                [ div [ class "absolute absolute--fill bg-black o-20 pointer ", onClick closeMsg ]
                    []
                , div
                    [ class "w-50 bg-white h30rem shadow-1 br3 z-1"
                    , role "dialog"
                    , tabindex 0
                    , id dialogId
                    , onKeyDown
                    ]
                    [ dialogInner ]
                ]
