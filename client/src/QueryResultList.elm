module QueryResultList exposing (view)

import Html exposing (Html, text, div, header, h2, h3, span, ul, li, button, p, a)
import Html.Attributes exposing (class, id, href, target, classList)
import Html.Attributes.Extra exposing (innerHtml)
import Html.Attributes.Aria exposing (ariaExpanded, ariaHidden, ariaControls, ariaLabelledby, ariaLabel)
import Html.Events exposing (onClick)
import Model exposing (Model, Msg(..))
import Set
import Util exposing (boolStr, viewIf, (!!))
import DataTypes exposing (QueryResult, AccordionsOpen, CountriesDictList, CountryId)
import Helpers.AppData exposing (getCountryName)


type alias ViewModel =
    { accordionsOpen : AccordionsOpen
    , queryResult : QueryResult
    , isCountryCompare : Bool
    , countries : CountriesDictList
    , resultIndex : Int
    , countryId : CountryId
    }


view : ViewModel -> Html Msg
view viewModel =
    let
        { queryResult, isCountryCompare, accordionsOpen, countries, resultIndex, countryId } =
            viewModel

        { matches, totalMatches } =
            queryResult

        countryName =
            getCountryName countryId countries

        headingText =
            "Showing " ++ toString (List.length matches) ++ " of " ++ toString (totalMatches) ++ " matches"

        flagClass =
            "f5 br-100 mr2 w1 h1 flag-icon flag-icon-squared flag-icon-" ++ String.toLower countryId
    in
        div [ class "bg-white shadow-2 w-100 ph4 pv3 relative" ]
            [ header []
                [ viewIf isCountryCompare
                    (div
                        [ class "f6 black-30 metro-b mv3 tc" ]
                        [ span [ class flagClass ] [], text countryName ]
                    )
                , h3
                    [ class "f6 black-30 metro-b mb2"
                    ]
                    [ text headingText ]
                , viewIf isCountryCompare
                    (button
                        [ class "icon icon--close absolute top-1 right-1 h1 w1 b--none bg-transparent"
                        , onClick (QueryResultListRemoveClick resultIndex)
                        , ariaLabel ("Remove " ++ countryName ++ " from comparison")
                        ]
                        []
                    )
                ]
            , ul [ class "list f5" ]
                (List.indexedMap
                    (\matchIndex match ->
                        let
                            accordionIsOpen =
                                Set.member ( match.id, matchIndex ) accordionsOpen

                            accordionClass =
                                classList
                                    [ ( "f7 bg-mid-gray mt1 mb2 br2 b--moon-gray ba pa3 lh-copy", True )
                                    , ( "dn", not accordionIsOpen )
                                    ]

                            accordionToggleClass =
                                classList
                                    [ ( "button-reset bg-white b--none icon icon--bullet-arrow near-black f6 pv1 pl3 lh-title w-100 tl relative"
                                      , True
                                      )
                                    , ( "icon--bullet-arrow-expanded", accordionIsOpen )
                                    ]

                            accordionHeadingId =
                                "heading" ++ match.id ++ toString matchIndex

                            accordionId =
                                "section" ++ match.id ++ toString matchIndex

                            emptyBody =
                                { tags = []
                                , text = "This result contains no body. It matched your search terms against its title only."
                                , offset = 0
                                , summary = match.title
                                , url = ""
                                , page = 0
                                }

                            matchHasBody =
                                0 !! match.body /= Nothing

                            snippet =
                                Maybe.withDefault emptyBody (0 !! match.body)
                        in
                            li [ class "near-black mw6 body-text" ]
                                [ button
                                    [ accordionToggleClass
                                    , ariaControls accordionId
                                    , onClick (AccordionToggleClick ( match.id, matchIndex ))
                                    ]
                                    [ span
                                        [ id accordionHeadingId
                                        , innerHtml snippet.summary
                                        ]
                                        []
                                    ]
                                , div
                                    [ accordionClass
                                    , id accordionId
                                    , ariaExpanded (boolStr accordionIsOpen)
                                    , ariaHidden (not accordionIsOpen)
                                    , ariaLabelledby accordionHeadingId
                                    ]
                                    [ div [ innerHtml snippet.text ] []
                                    , div []
                                        [ viewIf matchHasBody
                                            (text ("p." ++ toString snippet.page ++ ", "))
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
                    queryResult.matches
                )
            ]
