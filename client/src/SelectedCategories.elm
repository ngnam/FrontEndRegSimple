module SelectedCategories exposing (..)

import Html exposing (Html, section, div, a, button, input, header, img, text, ul, li, p)
import Html.Attributes exposing (id, class, tabindex, value, disabled, classList)
import Html.Events exposing (onClick)
import Model exposing (Model, Msg(Copy, CategorySubMenuClick, CategoryRemoveClick))
import CategorySelect exposing (Category, emptyCategory, getCategoriesFromIds)


subMenu : ( Model, Category ) -> Html Msg
subMenu ( model, category ) =
    let
        divider =
            div [ class "ba b--gray mh1" ] []

        subMenuOpen =
            model.categorySubMenuOpen == Just category.id

        menuClass =
            classList
                [ ( "shadow-2 absolute top-1 right--3 ba b--gray bg-white z-1 dark-grey", True )
                , ( "dn", not subMenuOpen )
                , ( "flex flex-column", subMenuOpen )
                ]

        isDisabled =
            ((List.length (model.categorySelect.selected)) == 1)

        countries =
            Maybe.withDefault "" model.countrySelect.selected

        activity =
            Maybe.withDefault "" model.activitySelect.selected

        copyLink =
            model.config.clientBaseUrl
                ++ "/#/query?"
                ++ "countries[]="
                ++ countries
                ++ "&activity[]="
                ++ activity
                ++ "&categories[]="
                ++ category.id
    in
        div [ menuClass ]
            [ header [ class "ttc f7 mv1 relative" ]
                [ text "Category actions"
                , button [ class "close-icon absolute top-0 right-0 mr1 bn pointer", onClick (CategorySubMenuClick category.id) ] []
                ]
            , divider
            , button [ class "bn tl mv1 pointer bg-white", onClick (Copy copyLink) ] [ text "Copy url..." ]
            , button [ class "bn tl mv1 pointer bg-white", disabled isDisabled, onClick (CategoryRemoveClick category.id) ] [ text "Remove from selected..." ]
            ]


categoriesMenu : Model -> Html Msg
categoriesMenu model =
    div [ class "flex flex-column" ]
        (List.map
            (\category ->
                let
                    categoryClass =
                        classList
                            [ ( "tl f7 bg-white shadow-1 mb1 pv3 ph2 min-h-20 black-30 pointer bn relative w-100", True )
                            , ( "bg-blue white", (Just category.id == model.activeCategory) )
                            ]

                    categoryMenuDotsClass =
                        classList
                            [ ( "absolute top-0 right-0 pa2 mr1 bn", True )
                            , ( "menu-dots--white bg-blue", (Just category.id == model.activeCategory) )
                            , ( "menu-dots bg-white", (Just category.id /= model.activeCategory) )
                            ]
                in
                    div [ class "relative" ]
                        [ button
                            [ categoryClass, onClick (Model.SetActiveCategory category.id), tabindex 0 ]
                            [ text category.name ]
                        , button [ categoryMenuDotsClass, onClick (CategorySubMenuClick category.id) ] []
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
