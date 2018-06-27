module QueryResultList exposing (view)

import Html exposing (Html, text, div, h2, span, ul, li, button, p, a)
import Html.Attributes exposing (class, id, href, target)
import Html.Attributes.Extra exposing (innerHtml)
import Html.Attributes.Aria exposing (ariaExpanded, ariaHidden, ariaControls, ariaLabelledby)
import Html.Events exposing (onClick)
import Model exposing (Model, Msg(..))
import ClassNames exposing (classNames)
import Set
import Util exposing (boolStr, (!!))
import DataTypes exposing (QueryResultsMatchBody)


view : Model -> Html Msg
view model =
    let
        { matches, totalMatches } =
            model.queryResults

        headingText =
            toString (List.length matches) ++ " of " ++ toString (totalMatches) ++ " matches shown"
    in
        div [ class "white shadow-2 w-100 pa4" ]
            [ h2
                [ class "f6 black-30 metro-b mb2"
                , innerHtml headingText
                ]
                []
            , ul [ class "list f5" ]
                (List.indexedMap
                    (\index match ->
                        let
                            accordionIsOpen =
                                Set.member ( match.id, index ) model.accordionsOpen

                            accordionClass =
                                classNames
                                    [ ( "f7 bg-mid-gray mt1 mb2 br2 b--moon-gray ba pa3 lh-copy", True )
                                    , ( "dn", not accordionIsOpen )
                                    ]

                            accordionToggleClass =
                                classNames
                                    [ ( "button-reset bg-white b--none arrow-bullet pointer near-black f6 pv1 pl3 lh-title w-100 tl relative"
                                      , True
                                      )
                                    , ( "arrow-bullet--expanded", accordionIsOpen )
                                    ]

                            accordionHeadingId =
                                "heading" ++ match.id ++ toString index

                            accordionId =
                                "section" ++ match.id ++ toString index

                            emptyBody =
                                { tags = []
                                , text = ""
                                , offset = 0
                                , summary = ""
                                , url = ""
                                , page = 0
                                }

                            snippet =
                                Maybe.withDefault emptyBody (0 !! match.body)
                        in
                            li [ class "near-black mw6" ]
                                [ button
                                    [ class accordionToggleClass
                                    , ariaControls accordionId
                                    , onClick (AccordionToggleClick ( match.id, index ))
                                    ]
                                    [ span
                                        [ id accordionHeadingId
                                        , innerHtml snippet.summary
                                        ]
                                        []
                                    ]
                                , div
                                    [ class accordionClass
                                    , id accordionId
                                    , ariaExpanded (boolStr accordionIsOpen)
                                    , ariaHidden (not accordionIsOpen)
                                    , ariaLabelledby accordionHeadingId
                                    ]
                                    [ div [ innerHtml snippet.text ] []
                                    , div []
                                        [ text ("p." ++ toString snippet.page ++ ", ")
                                        , a
                                            [ href snippet.url
                                            , target "_blank"
                                            , innerHtml match.title
                                            ]
                                            []
                                        ]
                                    ]
                                ]
                    )
                    model.queryResults.matches
                )
            ]
