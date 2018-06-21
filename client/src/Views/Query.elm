module Views.Query exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, text, div, p, h1, span, ul, li)
import Html.Attributes exposing (class, tabindex)
import QueryNavBar
import QuerySideBar
import SelectedCategories
import QueryResultList


view : Model -> Html Msg
view model =
    div [ class "flex min-vh-100" ]
        [ QuerySideBar.view model
        , div [ class "flex-1 flex flex-column" ]
            [ QueryNavBar.view model
            , div [ class "flex-1 flex" ]
                [ SelectedCategories.view model
                , div [ class "tl flex-1 ph4 pv3 mb3 near-black w-75" ]
                    [ h1 [ class "f5 mb3" ] [ text model.activeCategory.name ]
                    , QueryResultList.view model
                    ]
                ]
            ]
        ]
