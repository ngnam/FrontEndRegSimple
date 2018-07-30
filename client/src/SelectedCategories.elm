module SelectedCategories exposing (..)

import Html exposing (Html, section, div, a, button, input, header, img, text, ul, li, p, span)
import Html.Attributes exposing (id, class, tabindex, value, disabled, classList, href, target)
import Html.Events exposing (onClick, onFocus, onBlur)
import Model exposing (Model, Msg(Copy, SetCategorySubMenuFocus, CategoryRemoveClick))
import Helpers.AppData exposing (emptyCategory, getCategoriesFromIds)
import Helpers.CountrySelect exposing (getSelectedCountryIds)
import Helpers.QueryString exposing (queryStringFromRecord)
import RemoteData exposing (RemoteData(..))
import DataTypes exposing (Category)


subMenu : ( Model, Category ) -> Html Msg
subMenu ( model, category ) =
    let
        subMenuOpen =
            model.categorySubMenuOpen == Just category.id

        menuClass =
            classList
                [ ( "shadow-2 absolute top-1 right--3 ba br1 b--moon-gray bg-white z-1 dark-grey", True )
                , ( "dn", not subMenuOpen )
                , ( "flex flex-column", subMenuOpen )
                ]

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

        submenuButtonClass =
            "icon icon--category-submenu-btn relative bn tl f7 pv1 pl3 mb1 bg-white w-100 db near-black no-underline"
    in
        div
            [ menuClass
            , tabindex 0
            , onFocus (SetCategorySubMenuFocus (Just category.id))
            , onBlur (SetCategorySubMenuFocus Nothing)
            ]
            [ header [ class "ttc f7 h1 mv1 flex justify-center items-center dark-gray" ]
                [ text "Category actions"
                , button
                    [ class "icon icon--close-small absolute top-0 right-0 w1 h1 ma1 bn bg-white"
                    , onClick (SetCategorySubMenuFocus Nothing)
                    , onFocus (SetCategorySubMenuFocus (Just category.id))
                    ]
                    []
                ]
            , ul [ class "pv1 mh1 bt bb b--black-20 mb1 list tl" ]
                [ li []
                    [ button
                        [ classList
                            [ ( submenuButtonClass, True )
                            , ( "icon--copy", True )
                            ]
                        , onClick (Copy copyLink)
                        , onFocus (SetCategorySubMenuFocus (Just category.id))
                        , onBlur (SetCategorySubMenuFocus Nothing)
                        ]
                        [ text "Copy URL..." ]
                    ]
                , li []
                    [ a
                        [ classList
                            [ ( submenuButtonClass, True )
                            , ( "icon--download", True )
                            ]
                        , href downloadLink
                        , target "_blank"
                        , onFocus (SetCategorySubMenuFocus (Just category.id))
                        , onBlur (SetCategorySubMenuFocus Nothing)
                        ]
                        [ text "Download as PDF.." ]
                    ]
                , li []
                    [ button
                        [ classList
                            [ ( submenuButtonClass, True )
                            , ( "icon--trash", True )
                            ]
                        , disabled isDisabled
                        , onClick (CategoryRemoveClick category.id)
                        , onFocus (SetCategorySubMenuFocus (Just category.id))
                        , onBlur (SetCategorySubMenuFocus Nothing)
                        ]
                        [ text "Remove from selected..." ]
                    ]
                ]
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
                            , onClick (SetCategorySubMenuFocus (Just category.id))
                            , onBlur (SetCategorySubMenuFocus Nothing)
                            ]
                            []
                        , subMenu ( model, category )
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
