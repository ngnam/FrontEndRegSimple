module SelectedCategories exposing (..)

import Html exposing (Html, section, div, a, button, img, text, ul, li, p)
import Html.Attributes exposing (class, src, href)
import Model exposing (Model, Msg)


categoriesMenu : Model -> Html msg
categoriesMenu model =
    ul [ class "list flex flex-column" ]
        (List.indexedMap
            (\index category ->
                li
                    [ class "tl f7 bg-white shadow-1 mb1 pv2 ph2 min-h-20 black-30 pointer" ]
                    [ text category.name ]
            )
            model.categorySelect.selected
        )


view : Model -> Html Msg
view model =
    section [ class "bg-mid-gray w5 h-100 pa1" ]
        [ p [ class "tl ttc f7 mb1 metro-b black-30" ] [ text "Selected categories" ]
        , categoriesMenu model
        ]
