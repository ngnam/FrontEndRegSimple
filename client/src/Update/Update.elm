port module Update exposing (..)

import Model exposing (Model, Msg(..))
import Debouncer
import Navigation
import LoginEmailDecoder
import LoginCodeDecoder
import QueryDecoder
import AppDataDecoder
import CountrySelect
import ActivitySelect exposing (ActivityId)
import CategorySelect exposing (CategoryId)
import Helpers.Routing exposing (onUrlChange)
import Helpers.QueryString exposing (queryString, removeFromQueryString)
import Helpers.AppData exposing (getActivities, getCategories, getCountries, getCountriesDict)
import Helpers.CountrySelect exposing (getCountrySelect, getSelectedCountry)
import Set
import Dict
import Util exposing ((!!))
import DataTypes exposing (Taxonomy, emptyTaxonomy, CountryId, FeedbackType(..))
import RemoteData exposing (RemoteData(..), WebData)
import DictList
import FeedbackDecoder


getFromListById : String -> List { a | id : String } -> Maybe { a | id : String }
getFromListById id items =
    0 !! (List.filter (\item -> item.id == id) items)


setSelectedCategories : List CategoryId -> Model -> Model
setSelectedCategories categoryIds model =
    let
        { categorySelect } =
            model

        updatedCategorySelect =
            { categorySelect
                | selected = categoryIds
            }
    in
        { model | categorySelect = updatedCategorySelect }


setSelectedActivity : Maybe ActivityId -> Model -> Model
setSelectedActivity maybeId model =
    let
        { activitySelect } =
            model

        id =
            case maybeId of
                Just "" ->
                    Nothing

                Just id ->
                    Just id

                Nothing ->
                    Nothing

        updatedActivitySelect =
            { activitySelect | selected = id }
    in
        { model | activitySelect = updatedActivitySelect }


setSelectedCountries : List CountryId -> Model -> Model
setSelectedCountries ids model =
    let
        { countrySelect } =
            model

        countryId maybeId =
            case maybeId of
                Just "" ->
                    Nothing

                Just id ->
                    Just id

                Nothing ->
                    Nothing

        countrySelect1 =
            getCountrySelect 0 model

        countrySelect2 =
            getCountrySelect 1 model

        newCountrySelect =
            countrySelect
                |> Dict.insert 0 { countrySelect1 | selected = countryId (0 !! ids) }
                |> Dict.insert 1 { countrySelect2 | selected = countryId (1 !! ids) }
    in
        { model
            | countrySelect = newCountrySelect
        }


setFilterText : Maybe String -> Model -> Model
setFilterText maybeFilterText model =
    case maybeFilterText of
        Just filterText ->
            { model | filterText = filterText }

        Nothing ->
            { model | filterText = "" }


removeSnippetFromResults snippetId queryResult =
    { queryResult
        | matches =
            (List.filter
                (\match ->
                    (match.body
                        |> List.head
                        |> Maybe.map .id
                        |> Maybe.withDefault ""
                    )
                        /= snippetId
                )
                queryResult.matches
            )
        , nMatches = queryResult.nMatches - 1
        , totalMatches = queryResult.totalMatches - 1
    }


port copy : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                newModel =
                    onUrlChange location model

                taxonomy =
                    case model.appData of
                        Success appData ->
                            appData.taxonomy

                        _ ->
                            emptyTaxonomy

                queryUpdate =
                    setSelectedCategories
                        (Maybe.withDefault [] (Dict.get "categories" newModel.search))
                        >> setSelectedActivity
                            (0 !! (Maybe.withDefault [] (Dict.get "activity" newModel.search)))
                        >> setSelectedCountries
                            (Maybe.withDefault [] (Dict.get "countries" newModel.search))
                        >> setFilterText
                            (0 !! (Maybe.withDefault [] (Dict.get "filterText" newModel.search)))

                appDataCmd =
                    if model.navCount == 0 then
                        AppDataDecoder.requestCmd newModel
                    else
                        Cmd.none

                queryCmd =
                    case newModel.location.hash of
                        "#/query" ->
                            QueryDecoder.requestCmd newModel

                        _ ->
                            Cmd.none

                updatedModel =
                    case newModel.location.hash of
                        "#/query" ->
                            queryUpdate newModel

                        _ ->
                            newModel
            in
                ( { updatedModel
                    | navCount = model.navCount + 1
                    , queryResults = Loading
                  }
                , Cmd.batch [ appDataCmd, queryCmd ]
                )

        LoginEmailFormOnInput email ->
            ( { model | email = email }, Cmd.none )

        LoginEmailFormOnSubmit ->
            ( { model | loginEmailResponse = Loading }, LoginEmailDecoder.requestCmd model )

        LoginEmailFormOnResponse response ->
            ( { model | loginEmailResponse = response }, Cmd.none )

        LoginCodeFormOnInput code ->
            ( { model | loginCode = code }, Cmd.none )

        LoginCodeFormOnSubmit ->
            ( { model | loginCodeResponse = Loading }, LoginCodeDecoder.requestCmd model )

        LoginCodeFormOnResponse response ->
            ( { model
                | loginCodeResponse = response
                , isLoggedIn =
                    case response of
                        Success _ ->
                            True

                        _ ->
                            False
              }
            , case response of
                Success _ ->
                    Navigation.modifyUrl "/#/"

                _ ->
                    Cmd.none
            )

        SetActiveCategory categoryId ->
            ( { model | activeCategory = Just categoryId }, Cmd.none )

        FilterTextOnInput filterText ->
            let
                ( debouncer, debouncerCmd ) =
                    model.debouncer |> Debouncer.bounce { id = "filterText", msgToSend = OnQueryUpdate }

                newModel =
                    { model | filterText = filterText, debouncer = debouncer }
            in
                (newModel
                    ! [ debouncerCmd |> Cmd.map DebouncerSelfMsg ]
                )

        OnQueryUpdate ->
            ( model, Navigation.modifyUrl ("/#/query?" ++ (queryString model)) )

        DebouncerSelfMsg debouncerMsg ->
            let
                ( debouncer, cmd ) =
                    model.debouncer |> Debouncer.process debouncerMsg
            in
                { model | debouncer = debouncer } ! [ cmd ]

        CountrySelectMsg index subMsg ->
            let
                ( updatedCountrySelectModel, countrySelectCmd ) =
                    CountrySelect.update subMsg (getCountrySelect index model)

                newCountrySelect =
                    Dict.insert index updatedCountrySelectModel model.countrySelect

                newModel =
                    { model
                        | countrySelect = newCountrySelect
                    }

                selectedHasChanged =
                    getSelectedCountry index model /= getSelectedCountry index newModel

                queryCmd =
                    if newModel.location.hash == "#/query" && selectedHasChanged then
                        Navigation.modifyUrl ("/#/query?" ++ (queryString newModel))
                    else
                        Cmd.none
            in
                ( newModel
                , Cmd.batch
                    [ Cmd.map (CountrySelectMsg index) countrySelectCmd, queryCmd ]
                )

        ActivitySelectMsg subMsg ->
            let
                ( updatedActivitySelectModel, activitySelectCmd ) =
                    ActivitySelect.update subMsg model.activitySelect

                selected =
                    Maybe.withDefault "" updatedActivitySelectModel.selected

                { categorySelect } =
                    model

                taxonomy =
                    case model.appData of
                        Success appData ->
                            appData.taxonomy

                        _ ->
                            emptyTaxonomy

                newCategoryModel =
                    { categorySelect | options = getCategories taxonomy selected }

                newModel =
                    { model
                        | activitySelect = updatedActivitySelectModel
                        , categorySelect = newCategoryModel
                    }

                selectedHasChanged =
                    model.activitySelect.selected /= newModel.activitySelect.selected

                queryCmd =
                    if newModel.location.hash == "#/query" && selectedHasChanged then
                        Navigation.modifyUrl ("/#/query?" ++ (queryString newModel))
                    else
                        Cmd.none
            in
                ( newModel
                , Cmd.batch [ Cmd.map ActivitySelectMsg activitySelectCmd, queryCmd ]
                )

        AccordionToggleClick snippetId ->
            let
                accordionIsOpen =
                    Set.member snippetId model.accordionsOpen

                accordionsOpen =
                    if not accordionIsOpen then
                        Set.insert snippetId model.accordionsOpen
                    else
                        Set.remove snippetId model.accordionsOpen
            in
                ( { model | accordionsOpen = accordionsOpen }, Cmd.none )

        CategorySelectMsg subMsg ->
            let
                ( updatedCategorySelectModel, categorySelectCmd ) =
                    CategorySelect.update subMsg model.categorySelect

                newModel =
                    { model
                        | categorySelect = updatedCategorySelectModel
                    }

                selectedHasChanged =
                    model.categorySelect.selected /= newModel.categorySelect.selected

                queryCmd =
                    if newModel.location.hash == "#/query" && selectedHasChanged then
                        Navigation.modifyUrl ("/#/query?" ++ (queryString newModel))
                    else
                        Cmd.none
            in
                ( newModel
                , Cmd.batch [ Cmd.map CategorySelectMsg categorySelectCmd, queryCmd ]
                )

        CategorySubMenuClick categoryId ->
            case Just categoryId == model.categorySubMenuOpen of
                True ->
                    ( { model | categorySubMenuOpen = Nothing }, Cmd.none )

                _ ->
                    ( { model | categorySubMenuOpen = Just categoryId }, Cmd.none )

        CategoryRemoveClick categoryId ->
            let
                { categorySelect } =
                    model

                newCategories =
                    List.filter (\selectedCategory -> selectedCategory /= categoryId)
                        categorySelect.selected

                updatedCategorySelectModel =
                    { categorySelect | selected = newCategories }
            in
                ( { model | categorySelect = updatedCategorySelectModel }, Cmd.none )

        FetchQueryResults results ->
            ( { model | queryResults = results }, Cmd.none )

        FetchAppData results ->
            case results of
                Success data ->
                    let
                        { activitySelect, categorySelect, countrySelect } =
                            model

                        { countries, taxonomy } =
                            data

                        newActivityModel =
                            { activitySelect | options = getActivities taxonomy }

                        selected =
                            Maybe.withDefault "" activitySelect.selected

                        newCategoryModel =
                            { categorySelect | options = getCategories taxonomy selected }

                        countriesSorted =
                            countries
                                |> DictList.sortBy (\names -> Maybe.withDefault "" (List.head names))

                        cs1 =
                            getCountrySelect 0 model

                        cs2 =
                            getCountrySelect 1 model
                    in
                        ( { model
                            | appData = Success { taxonomy = taxonomy, countries = countriesSorted }
                            , activitySelect = newActivityModel
                            , categorySelect = newCategoryModel
                            , countrySelect =
                                countrySelect
                                    |> Dict.insert 0 { cs1 | countries = countriesSorted }
                                    |> Dict.insert 1 { cs2 | countries = countriesSorted }
                          }
                        , Cmd.none
                        )

                _ ->
                    ( { model | appData = results }, Cmd.none )

        Copy copyLink ->
            ( { model | categorySubMenuOpen = Nothing }, copy copyLink )

        QueryResultListRemoveClick index ->
            let
                { location, countrySelect } =
                    model

                countrySelect1 =
                    getCountrySelect 0 model

                countrySelect2 =
                    getCountrySelect 1 model

                newCountrySelect =
                    case index of
                        0 ->
                            countrySelect
                                |> Dict.insert 0 { countrySelect1 | query = countrySelect2.query }
                                |> Dict.insert 1 { countrySelect2 | query = "" }

                        1 ->
                            countrySelect
                                |> Dict.insert 1 { countrySelect2 | query = "" }

                        _ ->
                            countrySelect

                newQueryString =
                    removeFromQueryString location.search ( "countries", index )
            in
                ( { model
                    | countrySelect = newCountrySelect
                  }
                , Navigation.modifyUrl ("/#/query?" ++ newQueryString)
                )

        SnippetRejectClick ( snippetId, resultIndex ) ->
            let
                modifiedQueryResults =
                    case model.queryResults of
                        Success queryResults ->
                            Success
                                { results =
                                    (List.map
                                        (removeSnippetFromResults snippetId)
                                        queryResults.results
                                    )
                                }

                        _ ->
                            model.queryResults
            in
                ( { model | queryResults = modifiedQueryResults }, FeedbackDecoder.requestCmd model (RejectSnippet snippetId) )

        FeedbackRequest feedbackType results ->
            ( model
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )
