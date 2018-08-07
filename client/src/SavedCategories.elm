module SavedCategories exposing (..)

import Html exposing (Html, section, div, a, button, input, header, img, text, ul, li, p, span)
import Html.Attributes exposing (id, class, tabindex, value, disabled, classList, href, download)
import Html.Events exposing (onClick, onFocus, onBlur)
import Model exposing (Model, Msg(Copy, CategoryOptionsMenuSetFocus, CategoryRemoveClick))
import DictList
import Helpers.EmptyValues exposing (emptyQueryResultMatch, emptyQueryResultMatchBody)
import Helpers.AppData exposing (getCountryName)


-- categoryOptionsMenu : ( Model, Category ) -> Html Msg
-- categoryOptionsMenu ( model, category ) =
--     let
--         menuOpen =
--             model.categorySubMenuOpen == Just category.id
--
--         isDisabled =
--             ((List.length (model.categorySelect.selected)) == 1)
--
--         activityId =
--             Maybe.withDefault "" model.activitySelect.selected
--
--         queryString =
--             "?"
--                 ++ queryStringFromRecord
--                     { countries = getSelectedCountryIds model
--                     , categories = [ category.id ]
--                     , activity = [ activityId ]
--                     , filterText = ""
--                     }
--
--         copyLink =
--             model.config.clientBaseUrl
--                 ++ "/#/query"
--                 ++ queryString
--
--         downloadLink =
--             model.config.apiBaseUrl ++ "/query/pdf" ++ queryString
--
--         menuButtonClass =
--             OptionsMenu.buttonClass
--     in
--         optionsMenu
--             "Category actions"
--             menuOpen
--             (CategoryOptionsMenuSetFocus (Just category.id))
--             (CategoryOptionsMenuSetFocus Nothing)
--             [ ( button
--               , [ classList
--                     [ ( menuButtonClass, True )
--                     , ( "icon--copy", True )
--                     ]
--                 , onClick (Copy copyLink)
--                 ]
--               , [ text "Copy URL..." ]
--               )
--             , ( a
--               , [ classList
--                     [ ( menuButtonClass, True )
--                     , ( "icon--download", True )
--                     ]
--                 , href downloadLink
--                 , download True
--                 ]
--               , [ text "Download as PDF..." ]
--               )
--             , ( button
--               , [ classList
--                     [ ( menuButtonClass, True )
--                     , ( "icon--trash", True )
--                     ]
--                 , disabled isDisabled
--                 , onClick (CategoryRemoveClick category.id)
--                 ]
--               , [ text "Remove from selection..." ]
--               )
--             ]
-- snippetButton : DetailedSnippetBookmark -> Html Msg


snippetButton model detailedSnippetBookmark =
    let
        ( ( snippetId, categoryId, countryId ), snippetMetadata ) =
            detailedSnippetBookmark

        { body } =
            snippetMetadata

        country =
            snippetMetadata
                |> .country

        category =
            categoryId
    in
        div []
            [ p [] [ text category ]
            , divider
            , p [] [ text country ]
            ]


divider : Html msg
divider =
    div [ class "flex justify-center" ] [ span [ class "h2px w-90 bg-mid-gray" ] [] ]


categoriesMenu : Model -> Html Msg
categoriesMenu model =
    ul [ class "list flex flex-column" ]
        (List.map
            (\detailedSnippetBookmark ->
                let
                    ( snippetBookmarkKey, snippetMetadata ) =
                        detailedSnippetBookmark

                    categoryClass =
                        classList
                            [ ( "tl f7 bg-white shadow-1 br1 mb1 pv1 ph2 h4 black-30 bn relative w-100", True )
                            , ( "bg-blue white", (Just snippetBookmarkKey == model.activeBookmark) )
                            ]

                    categoryMenuDotsClass =
                        classList
                            [ ( "absolute top-0 right-0 w1 h1 mr1 bn relative icon icon--menu-dots bg-transparent", True )
                            , ( "icon--menu-dots-white", (Just snippetBookmarkKey == model.activeBookmark) )
                            , ( "icon--menu-dots-grey", (Just snippetBookmarkKey /= model.activeBookmark) )
                            ]

                    isLoading =
                        model.detailedSnippetBookmarks
                            |> DictList.values
                            |> List.member emptyQueryResultMatch

                    buttonInner =
                        case isLoading of
                            True ->
                                span [ class "dib w-100 h2 bg-mid-gray br2" ] []

                            False ->
                                snippetButton model detailedSnippetBookmark
                in
                    li [ class "relative" ]
                        [ button
                            [ categoryClass
                            , onClick (Model.SetActiveBookmark snippetBookmarkKey)
                            , tabindex 0
                            ]
                            [ buttonInner ]
                        , button
                            [ categoryMenuDotsClass

                            -- , onClick (CategoryOptionsMenuSetFocus (Just snippetBookmarkKey))
                            , onBlur (CategoryOptionsMenuSetFocus Nothing)
                            ]
                            []

                        -- , categoryOptionsMenu ( model, category )
                        ]
            )
            (DictList.toList model.detailedSnippetBookmarks)
        )


view : Model -> Html Msg
view model =
    section [ class "bg-mid-gray w5 min-h-100 pa1" ]
        [ p [ class "tl ttc f7 mb1 metro-b black-30" ] [ text "Saved bookmarks" ]
        , categoriesMenu model
        ]
