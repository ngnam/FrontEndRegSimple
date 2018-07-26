module OptionsMenu exposing (optionsMenu, buttonClass)

import Html exposing (Html, Attribute, div, ul, li, header, text, button)
import Html.Attributes exposing (classList, tabindex, class)
import Html.Events exposing (onFocus, onBlur, onClick)
import Model exposing (Msg)


buttonClass =
    "icon icon--category-submenu-btn relative bn tl f7 pv1 pl3 mb1 bg-white w-100 db near-black no-underline"


optionsMenu : String -> Bool -> Msg -> Msg -> List ( List (Attribute Msg) -> List (Html Msg) -> Html Msg, List (Attribute Msg), List (Html Msg) ) -> Html Msg
optionsMenu menuTitle isOpen openMsg closeMsg items =
    let
        menuClass =
            classList
                [ ( "shadow-2 absolute top-1 options-menu ba br1 b--moon-gray bg-white z-1 dark-grey", True )
                , ( "flex flex-column", isOpen )
                , ( "hide", not isOpen )
                ]
    in
        div
            [ menuClass
            , tabindex 0
            , onFocus openMsg
            , onBlur closeMsg
            ]
            [ header [ class "ttc f7 h1 mv1 flex justify-center items-center dark-gray" ]
                [ text menuTitle
                , button
                    [ class "icon icon--close-small absolute top-0 right-0 w1 h1 ma1 bn bg-white"
                    , onClick closeMsg
                    , onFocus openMsg
                    ]
                    []
                ]
            , ul [ class "pv1 mh1 bt bb b--black-20 mb1 list tl" ] <|
                List.map
                    (\item ->
                        let
                            ( tag, attrs, content ) =
                                item
                        in
                            li []
                                [ tag
                                    (List.concat [ attrs, [ onFocus openMsg, onBlur closeMsg ] ])
                                    content
                                ]
                    )
                    items
            ]
