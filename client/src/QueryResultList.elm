module QueryResultList exposing (view)

import Html exposing (Html, text, div, h2, span, ul, li, button)
import Html.Attributes exposing (class)
import Html.Attributes.Extra exposing (innerHtml)
import Html.Events exposing (onClick)
import Model exposing (Model, Msg(..))
import ClassNames exposing (classNames)
import Set


view : Model -> Html Msg
view model =
    div [ class "white shadow-2 w-100" ]
        (List.map
            (\match ->
                div [ class "near-black f5 pa3" ]
                    [ h2 [ class "f7 black-30 metro-b mb2" ] [ text match.title ]
                    , ul [ class "list" ]
                        (List.indexedMap
                            (\index regulation ->
                                let
                                    accordionIsOpen =
                                        Set.member ( match.id, index ) model.accordionsOpen

                                    accordionClass =
                                        classNames
                                            [ ( "f7 bg-mid-gray mt1 mb2 br2 b--moon-gray ba pa3", True )
                                            , ( "dn", not accordionIsOpen )
                                            ]
                                in
                                    li [ class "w-100" ]
                                        [ button
                                            [ class "button-reset bg-white b--none arrow-bullet pointer near-black f6 pv1 ph0 lh-title w-100 tl"
                                            , onClick (AccordionToggleClick ( match.id, index ))
                                            ]
                                            [ span [ class "lh-title" ]
                                                [ text (String.slice 3 28 regulation.text)
                                                ]
                                            ]
                                        , div
                                            [ class accordionClass
                                            , innerHtml regulation.text
                                            ]
                                            []
                                        ]
                            )
                            match.body
                        )
                    ]
            )
            model.queryResults.matches
        )
