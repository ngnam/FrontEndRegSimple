module Dialog.Dialog exposing (view)

import Html exposing (Html, Attribute, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id, class)
import Dialog.SnippetFeedback as SnippetFeedback


-- import Html.Attributes.Aria exposing (ariaControls)

import DataTypes exposing (DialogType(..))
import Model
    exposing
        ( Model
        , Msg
            ( DialogToggleClick
            , ActivityFeedbackClick
            )
        )


view : Model -> DialogType -> Html Msg
view model dialogType =
    let
        contents =
            case dialogType of
                SnippetFeedbackDialog ->
                    SnippetFeedback.view model

                NoDialog ->
                    text ""
    in
        div [ class "fixed absolute--fill flex justify-center items-center" ]
            [ div [ class "absolute absolute--fill bg-black o-20 pointer ", onClick (DialogToggleClick NoDialog Nothing) ]
                []
            , div
                [ class "w-50 bg-white h30rem z-1 shadow-1 br3 " ]
                [ contents ]
            ]
