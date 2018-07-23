module Dialog.Dialog exposing (view)

import Html exposing (Html, Attribute, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id, class)
import Model
    exposing
        ( Model
        , Msg
            ( SnippetFeedbackDialogCloseClick
            , ActivityFeedbackClick
            )
        )


view : Html Msg -> Html Msg
view dialogInner =
    div [ class "fixed absolute--fill flex justify-center items-center z-1" ]
        [ div [ class "absolute absolute--fill bg-black o-20 pointer ", onClick (SnippetFeedbackDialogCloseClick) ]
            []
        , div
            [ class "w-50 bg-white h30rem shadow-1 br3 z-1" ]
            [ dialogInner ]
        ]
