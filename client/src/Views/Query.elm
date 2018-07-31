module Views.Query exposing (..)

import Model exposing (Model, Msg(..))
import Html exposing (Html, main_, text, div, p, h1, span, ul, li, header)
import Html.Attributes exposing (class, tabindex, classList)
import QueryNavBar
import QuerySideBar
import SelectedCategories
import QueryResultList
import Helpers.AppData exposing (getCategoryById)
import Helpers.CountrySelect exposing (getSelectedCountry, getSelectedCountryIds)
import Helpers.QueryString exposing (queryValidation)
import Validation exposing (Validation(..))
import RemoteData exposing (RemoteData(..))
import DictList


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
        { accordionsOpen, appData, queryResults, session, snippetFeedback, snippetOptionsMenuOpen } =
            model

        countryIds =
            getSelectedCountryIds model

        categoryId =
            Maybe.withDefault "" model.activeCategory

        { name, description } =
            getCategoryById model.categorySelect.options categoryId

        countryCompareList =
            List.map
                (\countryId -> ( categoryId, countryId ))
                countryIds

        isCountryCompare =
            List.length countryIds > 1

        resultsContainerClass =
            classList
                [ ( "tl flex-1 flex flex-column ph5 pt3 pb4 near-black", True )
                , ( "mw7", not isCountryCompare )
                ]
    in
        main_ [ class "main--query flex" ]
            [ QuerySideBar.view model
            , div [ class "flex-1 flex flex-column" ]
                [ QueryNavBar.view model
                , div [ class "flex-1 flex" ]
                    [ SelectedCategories.view model
                    , div [ resultsContainerClass ]
                        [ viewHeader name description
                        , case ( queryValidation model, queryResults, appData ) of
                            ( Valid, Success results, Success appData ) ->
                                (div [ class "flex flex-row" ]
                                    (List.map
                                        (\categoryCountry ->
                                            let
                                                countryCompareResults =
                                                    DictList.get categoryCountry results

                                                countryId =
                                                    Tuple.second categoryCountry
                                            in
                                                case countryCompareResults of
                                                    Just countryCompareResults ->
                                                        QueryResultList.view
                                                            { accordionsOpen = accordionsOpen
                                                            , queryResult = countryCompareResults
                                                            , isCountryCompare = isCountryCompare
                                                            , categoryCountry = categoryCountry
                                                            , session = session
                                                            , countryId = countryId
                                                            , snippetFeedback = snippetFeedback
                                                            , appData = appData
                                                            , snippetOptionsMenuOpen = snippetOptionsMenuOpen
                                                            }

                                                    _ ->
                                                        text "Well this is embarrassing! We can't seem to find your search results"
                                        )
                                        countryCompareList
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
