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
        , div [ class "ml5 w-100" ]
            [ QueryNavBar.view model
            , SelectedCategories.view model
            , text ((toString model.queryResults.nMatches) ++ " results found")
            ]
        ]
