module Views.Query exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, text, div, p, h1, span, ul, li, header)
import Html.Attributes exposing (class, tabindex)
import QueryNavBar
import QuerySideBar
import SelectedCategories
import QueryResultList
import CategorySelect exposing (getCategoryById)


view : Model -> Html Msg
view model =
    let
        { name, description } =
            getCategoryById model.categorySelect.options (Maybe.withDefault "" model.activeCategory)
    in
        div [ class "flex min-vh-100" ]
            [ QuerySideBar.view model
            , div [ class "flex-1 flex flex-column" ]
                [ QueryNavBar.view model
                , div [ class "flex-1 flex" ]
                    [ SelectedCategories.view model
                    , div [ class "tl flex-1 ph5 pt3 pb4 near-black mw7" ]
                        [ header [ class "mb2 mw6" ]
                            [ h1 [ class "f5 mb2" ] [ text name ]
                            , p [ class "f6 lh-copy" ] [ text description ]
                            ]
                        , QueryResultList.view model
                        ]
                    ]
                ]
            ]
