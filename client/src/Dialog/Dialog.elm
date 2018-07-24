module Dialog.Dialog exposing (view)

import Html exposing (Html, Attribute, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id, class)
import Html.Attributes.Aria exposing (role, ariaHidden, ariaExpanded)
import Util exposing (boolStr)
import Json.Decode as Json
import Model
    exposing
        ( Model
        , Msg
            ( SnippetFeedbackDialogCloseClick
            , ActivityFeedbackClick
            )
        )


view : Html Msg -> Bool -> Html Msg
view dialogInner menuOpen =
    div
        [ class "fixed absolute--fill flex justify-center items-center z-1"
        , id "snippet-feedback-dialog"
        , ariaHidden (not menuOpen)
        , ariaExpanded (boolStr menuOpen)
        ]
        [ div [ class "absolute absolute--fill bg-black o-20 pointer ", onClick (SnippetFeedbackDialogCloseClick) ]
            []
        , div
            [ class "w-50 bg-white h30rem shadow-1 br3 z-1", role "dialog" ]
            [ dialogInner ]
        ]
