module SelectedCategories exposing (..)

import Html exposing (Html, section, div, a, button, input, header, img, text, ul, li, p, span)
import Html.Attributes exposing (id, class, tabindex, value, disabled, classList, href, target)
import Html.Events exposing (onClick, onFocus, onBlur)
import Model exposing (Model, Msg(Copy, CategoryOptionsMenuSetFocus, CategoryRemoveClick))
import Helpers.AppData exposing (emptyCategory, getCategoriesFromIds)
import Helpers.CountrySelect exposing (getSelectedCountryIds)
import Helpers.QueryString exposing (queryStringFromRecord)
import RemoteData exposing (RemoteData(..))
import DataTypes exposing (Category)
import OptionsMenu exposing (optionsMenu)


categoryOptionsMenu : ( Model, Category ) -> Html Msg
categoryOptionsMenu ( model, category ) =
    let
        menuOpen =
            model.categorySubMenuOpen == Just category.id

        isDisabled =
            ((List.length (model.categorySelect.selected)) == 1)

        activityId =
            Maybe.withDefault "" model.activitySelect.selected

        queryString =
            "?"
                ++ queryStringFromRecord
                    { countries = getSelectedCountryIds model
                    , categories = [ category.id ]
                    , activity = [ activityId ]
                    , filterText = ""
                    }

        copyLink =
            model.config.clientBaseUrl
                ++ "/#/query"
                ++ queryString

        downloadLink =
            model.config.apiBaseUrl ++ "/query/pdf" ++ queryString

        menuButtonClass =
            OptionsMenu.buttonClass
    in
        optionsMenu
            "Category actions"
            menuOpen
            (CategoryOptionsMenuSetFocus (Just category.id))
            (CategoryOptionsMenuSetFocus Nothing)
            [ ( button
              , [ classList
                    [ ( menuButtonClass, True )
                    , ( "icon--copy", True )
                    ]
                , onClick (Copy copyLink)
                ]
              , [ text "Copy URL..." ]
              )
            , ( a
              , [ classList
                    [ ( menuButtonClass, True )
                    , ( "icon--download", True )
                    ]
                , href downloadLink
                , target "_blank"
                ]
              , [ text "Download as PDF..." ]
              )
            , ( button
              , [ classList
                    [ ( menuButtonClass, True )
                    , ( "icon--trash", True )
                    ]
                , disabled isDisabled
                , onClick (CategoryRemoveClick category.id)
                ]
              , [ text "Remove from selection..." ]
              )
            ]


categoriesMenu : Model -> Html Msg
categoriesMenu model =
    ul [ class "list flex flex-column" ]
        (List.map
            (\category ->
                let
                    categoryClass =
                        classList
                            [ ( "tl f7 bg-white shadow-1 br1 mb1 pv1 ph2 min-h3rem black-30 bn relative w-100", True )
                            , ( "bg-blue white", (Just category.id == model.activeCategory) )
                            ]

                    categoryMenuDotsClass =
                        classList
                            [ ( "absolute top-0 right-0 w1 h1 mr1 bn relative icon icon--menu-dots bg-transparent", True )
                            , ( "icon--menu-dots-white", (Just category.id == model.activeCategory) )
                            , ( "icon--menu-dots-grey", (Just category.id /= model.activeCategory) )
                            ]

                    buttonInner =
                        case model.appData of
                            Loading ->
                                span [ class "dib w-100 h1 bg-mid-gray br2" ] []

                            _ ->
                                text category.name
                in
                    li [ class "relative" ]
                        [ button
                            [ categoryClass
                            , onClick (Model.SetActiveCategory category.id)
                            , tabindex 0
                            ]
                            [ buttonInner ]
                        , button
                            [ categoryMenuDotsClass
                            , onClick (CategoryOptionsMenuSetFocus (Just category.id))
                            , onBlur (CategoryOptionsMenuSetFocus Nothing)
                            ]
                            []
                        , categoryOptionsMenu ( model, category )
                        ]
            )
            (getCategoriesFromIds model.categorySelect.selected model.categorySelect.options)
        )


view : Model -> Html Msg
view model =
    section [ class "bg-mid-gray w5 min-h-100 pa1" ]
        [ p [ class "tl ttc f7 mb1 metro-b black-30" ] [ text "Selected categories" ]
        , categoriesMenu model
        ]
