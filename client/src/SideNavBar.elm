module SideNavBar exposing (..)

import Html exposing (Html, nav, div, a, button, p, img, text)
import Html.Attributes exposing (class, classList, src, href)
import Model exposing (Model, Msg)
import Helpers.QueryString exposing (queryString)


divider : Html msg
divider =
    div [ class "w-100 flex justify-center mv2" ] [ div [ class "bg-white h1px w-70" ] [] ]


view : Model -> Html Msg
view model =
    let
        backgroundClass =
            classList
                [ ( "flex items-center justify-center w3 h3 mh2"
                  , True
                  )
                , ( "bg-light-purple br3", model.location.hash == "" )
                ]
    in
        nav [ class "w3 min-h-100 bg-dark-blue pt3" ]
            [ a [ href "/#/" ] [ img [ class "w2", src "assets/logos/logo-icon.svg" ] [] ]
            , div [ class "mt2" ]
                [ div [ class "flex justify-center" ]
                    [ div
                        [ classList
                            [ ( "flex items-center justify-center w3 h3 mh2"
                              , True
                              )
                            , ( "bg-light-purple br3", model.location.hash == "#/" )
                            ]
                        ]
                        [ a [ class "link dim", href "/#/" ]
                            [ img [ class "w-60", src "assets/icons/home.svg" ] []
                            , p [ class "white f7" ] [ text "Home" ]
                            ]
                        ]
                    ]
                , divider
                , div [ class "flex justify-center" ]
                    [ div
                        [ classList
                            [ ( "flex items-center justify-center w3 h3 mh2"
                              , True
                              )
                            , ( "bg-light-purple br3", model.location.hash == "#/query" )
                            ]
                        ]
                        [ a [ class "link dim", href ("/#/query?" ++ queryString model) ]
                            [ img [ class "w-60", src "assets/icons/search.svg" ] []
                            , p [ class "white f7" ] [ text "Search" ]
                            ]
                        ]
                    ]
                , divider
                , div [ class "flex justify-center" ]
                    [ div
                        [ classList
                            [ ( "flex items-center justify-center w3 h3 mh2"
                              , True
                              )
                            , ( "bg-light-purple br3", model.location.hash == "#/bookmarks" )
                            ]
                        ]
                        [ a [ class "link dim", href "/#/bookmarks" ]
                            [ img [ class "w-60", src "assets/icons/bookmark.svg" ] []
                            , p [ class "white f7" ] [ text "Saved" ]
                            ]
                        ]
                    ]
                ]
            ]
