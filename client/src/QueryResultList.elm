module QueryResultList exposing (view)

import Html exposing (Html, text, div, header, h2, h3, span, ul, li, button, p, a)
import Html.Attributes exposing (class, id, href, target, classList)
import Html.Attributes.Extra exposing (innerHtml)
import Html.Attributes.Aria exposing (ariaExpanded, ariaHidden, ariaControls, ariaLabelledby, ariaLabel)
import Html.Events exposing (onClick, onBlur)
import Model exposing (Model, Msg(..))
import Set
import Util exposing (boolStr, viewIf, (!!))
import DataTypes exposing (QueryResult, AccordionsOpen, CountryId, Session, Role(..), CategoryCountry, AppData, SnippetFeedback, SnippetId)
import Helpers.AppData exposing (getCountryName)
import Helpers.Session exposing (isMinRole)
import Dialog.SnippetFeedback exposing (snippetFeedbackDialog)
import OptionsMenu exposing (optionsMenu)


type alias ViewModel =
    { accordionsOpen : AccordionsOpen
    , queryResult : QueryResult
    , isCountryCompare : Bool
    , categoryCountry : CategoryCountry
    , countryId : CountryId
    , session : Session
    , appData : AppData
    , snippetFeedback : SnippetFeedback
    , snippetOptionsMenuOpen : Maybe SnippetId
    }


snippetOptionsMenu { snippetOptionsMenuOpen, snippet, categoryCountry, snippetFeedback, appData } =
    let
        isOpen =
            snippetOptionsMenuOpen == Just snippet.id

        categoryId =
            Tuple.first categoryCountry

        dialogId =
            "snippet-" ++ snippet.id ++ "-feedback-dialog"
    in
        optionsMenu
            "Snippet actions"
            isOpen
            (SnippetOptionsMenuSetFocus (Just snippet.id))
            (SnippetOptionsMenuSetFocus Nothing)
            [ ( button
              , [ classList
                    [ ( OptionsMenu.buttonClass, True )
                    , ( "icon--thumbs-up", True )
                    ]
                , onClick <| SnippetVoteUpClick ( snippet.id, categoryId )
                ]
              , [ text "Vote up" ]
              )
            , ( button
              , [ classList
                    [ ( OptionsMenu.buttonClass, True )
                    , ( "icon--thumbs-down", True )
                    ]
                , onClick <| SnippetVoteDownClick ( snippet.id, categoryId )
                ]
              , [ text "Vote down" ]
              )
            , ( button
              , [ classList
                    [ ( OptionsMenu.buttonClass, True )
                    , ( "icon--copy", True )
                    ]
                , onClick <|
                    SnippetFeedbackDialogOpenClick
                        dialogId
                        (Just ( snippet.id, categoryCountry ))
                , ariaControls "snippet-feedback-dialog"
                ]
              , [ text "Reassign snippet" ]
              )
            , ( span
              , []
              , [ snippetFeedbackDialog
                    { snippetFeedback = snippetFeedback, appData = appData }
                    dialogId
                    snippetFeedback.dialogOpen
                ]
              )
            , ( button
              , [ classList
                    [ ( OptionsMenu.buttonClass, True )
                    , ( "icon--trash", True )
                    ]
                , onClick <| SnippetSuggestClick <| Just ( snippet.id, categoryCountry )
                ]
              , [ text "Reject snippet" ]
              )
            ]


view : ViewModel -> Html Msg
view viewModel =
    let
        { queryResult, isCountryCompare, accordionsOpen, categoryCountry, countryId, session, snippetFeedback, appData, snippetOptionsMenuOpen } =
            viewModel

        { matches, totalMatches } =
            queryResult

        countryName =
            getCountryName countryId appData.countries

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
                        , onClick (QueryResultListRemoveClick categoryCountry)
                        , ariaLabel ("Remove " ++ countryName ++ " from comparison")
                        ]
                        []
                    )
                ]
            , ul [ class "list f5" ]
                (List.map
                    (\match ->
                        let
                            emptyBody =
                                { tags = []
                                , text = "This result contains no body. It matched your search terms against its title only."
                                , offset = 0
                                , summary = match.title
                                , url = ""
                                , page = 0
                                , id = ""
                                }

                            matchHasBody =
                                0 !! match.body /= Nothing

                            snippet =
                                Maybe.withDefault emptyBody (0 !! match.body)

                            accordionIsOpen =
                                Set.member snippet.id accordionsOpen

                            accordionClass =
                                classList
                                    [ ( "f7 bg-mid-gray mt1 mb2 br2 b--moon-gray ba pa3 lh-copy relative", True )
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
                                "heading" ++ snippet.id

                            accordionId =
                                "section" ++ snippet.id
                        in
                            li [ class "near-black mw6 body-text" ]
                                [ button
                                    [ accordionToggleClass
                                    , ariaControls accordionId
                                    , onClick (AccordionToggleClick snippet.id)
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
                                    , viewIf (isMinRole RoleEditor session)
                                        (button
                                            [ class "icon icon--menu-dots icon--menu-dots-grey absolute top-0 right-0 ma1 h1 w1 bg-mid-gray bn"
                                            , onClick (SnippetOptionsMenuSetFocus (Just snippet.id))
                                            , onBlur (SnippetOptionsMenuSetFocus Nothing)
                                            , ariaControls "snippet-feedback-dialog"
                                            ]
                                            []
                                        )
                                    , snippetOptionsMenu
                                        { snippetOptionsMenuOpen = snippetOptionsMenuOpen
                                        , snippet = snippet
                                        , categoryCountry = categoryCountry
                                        , snippetFeedback = snippetFeedback
                                        , appData = appData
                                        }
                                    ]
                                ]
                    )
                    queryResult.matches
                )
            ]
