module Views.Query exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, text, div, p, h1, span, ul, li, header)
import Html.Attributes exposing (class, tabindex, classList)
import QueryNavBar
import QuerySideBar
import SelectedCategories
import QueryResultList
import CategorySelect exposing (getCategoryById)
import Helpers.CountrySelect exposing (getSelectedCountry)
import Helpers.QueryString exposing (queryValidation)
import Validation exposing (Validation(..))
import RemoteData exposing (RemoteData(..))
import DataTypes exposing (Role(..))


viewValidationText : String -> Html msg
viewValidationText validationText =
    header [ class "mb2 mw6" ]
        [ h1 [ class "f5 mb2" ] [ text validationText ]
        ]


viewHeader : String -> String -> Html msg
viewHeader name description =
    header [ class "mb2 mw6" ]
        [ h1 [ class "f5 mb2" ] [ text name ]
        , p [ class "f6 lh-copy" ] [ text description ]
        ]


view : Model -> Html Msg
view model =
    let
        { accordionsOpen, appData, queryResults, session } =
            model

        { name, description } =
            getCategoryById model.categorySelect.options (Maybe.withDefault "" model.activeCategory)

        isCountryCompare =
            case queryResults of
                Success query ->
                    List.length query.results > 1

                _ ->
                    False

        resultsContainerClass =
            classList
                [ ( "tl flex-1 flex flex-column ph5 pt3 pb4 near-black", True )
                , ( "mw7", not isCountryCompare )
                ]
    in
        div [ class "flex min-vh-100" ]
            [ QuerySideBar.view model
            , div [ class "flex-1 flex flex-column" ]
                [ QueryNavBar.view model
                , div [ class "flex-1 flex" ]
                    [ SelectedCategories.view model
                    , div [ resultsContainerClass ]
                        [ viewHeader name description
                        , case ( queryValidation model, queryResults, appData ) of
                            ( Valid, Success queryResults, Success appData ) ->
                                (div [ class "flex flex-row" ]
                                    (List.indexedMap
                                        (\index queryResult ->
                                            QueryResultList.view
                                                { accordionsOpen = accordionsOpen
                                                , queryResult = queryResult
                                                , isCountryCompare = isCountryCompare
                                                , countries = appData.countries
                                                , resultIndex = index
                                                , session = session
                                                , countryId =
                                                    Maybe.withDefault
                                                        ""
                                                        (getSelectedCountry index model)
                                                }
                                        )
                                        queryResults.results
                                    )
                                )

                            ( Invalid validationText, _, Success appData ) ->
                                viewValidationText validationText

                            ( _, _, Failure error ) ->
                                div [] [ text "There was a problem connecting to our servers. Please check your internet connection and try again." ]

                            ( _, Failure error, _ ) ->
                                div [] [ text "There was an error loading your search results." ]

                            ( _, Loading, _ ) ->
                                div
                                    [ class "w-100 relative flex-1" ]
                                    [ div [ class "spinner" ] [] ]

                            _ ->
                                div [] []
                        ]
                    ]
                ]
            ]
