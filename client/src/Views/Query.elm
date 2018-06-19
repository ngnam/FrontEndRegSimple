module Views.Query exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, text, div, p, span, ul, li)
import Html.Attributes exposing (class, tabindex)
import QueryNavBar
import QuerySideBar
import SelectedCategories


regulationResults : Model -> Html msg
regulationResults model =
    div [ class "white shadow-1 w-100" ]
        (List.map
            (\match ->
                div [ class "near-black f5 pa3" ]
                    [ p [ class "f7 black-30 metro-b mb2" ] [ text match.title ]
                    , ul [ class "list" ]
                        (List.map
                            (\regulation ->
                                li [ class "arrow-bullet pointer near-black f7 pv3", tabindex 0 ] [ text regulation.text ]
                            )
                            match.body
                        )
                    ]
            )
            model.queryResults.matches
        )


view : Model -> Html Msg
view model =
    div [ class "flex vh-100" ]
        [ QuerySideBar.view model
        , div [ class "flex-1 flex flex-column" ]
            [ QueryNavBar.view model
            , div [ class "flex-1 flex" ]
                [ SelectedCategories.view model
                , div [ class "tl flex-1 ph4 pv3 mb3 near-black w-75" ]
                    [ p [] [ text model.activeCategory.name ]
                    , regulationResults model
                    ]
                ]
            ]
        ]
