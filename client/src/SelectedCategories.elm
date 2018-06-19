module SelectedCategories exposing (..)

import Html exposing (Html, section, div, a, button, img, text, ul, li, p)
import Html.Attributes exposing (class, src, href)
import Html.Events exposing (onClick)
import Model exposing (Model, Msg)
import ClassNames exposing (classNames)
import CategorySelect exposing (emptyCategory)


categoriesMenu : Model -> Html Msg
categoriesMenu model =
    ul [ class "list flex flex-column" ]
        (List.indexedMap
            (\index category ->
                let
                    isEmptyCategory =
                        ()

                    categoryClass =
                        classNames
                            [ ( "tl f7 bg-white shadow-1 mb1 pv2 ph2 min-h-20 black-30 pointer", True )
                            , ( "bg-blue white", (model.activeCategory == emptyCategory && index == 0) || category == model.activeCategory )
                            ]
                in
                    li
                        [ class categoryClass, onClick (Model.SetActiveCategory category) ]
                        [ text category.name ]
            )
            model.categorySelect.selected
        )


view : Model -> Html Msg
view model =
    section [ class "bg-mid-gray w5 min-h-100 pa1" ]
        [ p [ class "tl ttc f7 mb1 metro-b black-30" ] [ text "Selected categories" ]
        , categoriesMenu model
        ]
