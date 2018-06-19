module Views.Query exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, text, div)
import Html.Attributes exposing (class)
import QueryNavBar
import QuerySideBar
import SelectedCategories


view : Model -> Html Msg
view model =
    div [ class "flex vh-100" ]
        [ QuerySideBar.view model
        , div [ class "flex-auto flex flex-column" ]
            [ QueryNavBar.view model
            , div [ class "flex-auto flex" ]
                [ SelectedCategories.view model
                , div [ class "flex-auto" ]
                    [ text ((toString model.queryResults.nMatches) ++ " results found") ]
                ]
            ]
        ]
