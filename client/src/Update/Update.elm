port module Update exposing (..)

import Model exposing (Model, Msg(..))
import Debouncer
import Navigation
import LoginDecoder exposing (requestLoginCodeCmd)
import QueryDecoder
import HomeDataDecoder
import CountrySelect exposing (CountryId)
import ActivitySelect exposing (ActivityId)
import CategorySelect exposing (CategoryId)
import Helpers.Routing exposing (onUrlChange)
import Helpers.QueryString exposing (queryString, removeFromQueryString)
import Helpers.HomeData exposing (getActivities, getCategories, getCountries, getCountriesDict)
import Helpers.CountrySelect exposing (getCountrySelect, getSelectedCountry)
import Set
import Dict
import Util exposing ((!!))
import DataTypes exposing (Taxonomy)


getFromListById : String -> List { a | id : String } -> Maybe { a | id : String }
getFromListById id items =
    0 !! (List.filter (\item -> item.id == id) items)


setSelectedCategories : Taxonomy -> List CategoryId -> Model -> Model
setSelectedCategories homeData categoryIds model =
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


port copy : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                newModel =
                    onUrlChange location model

                queryUpdate =
                    setSelectedCategories model.homeData
                        (Maybe.withDefault [] (Dict.get "categories" newModel.search))
                        >> setSelectedActivity
                            (0 !! (Maybe.withDefault [] (Dict.get "activity" newModel.search)))
                        >> setSelectedCountries
                            (Maybe.withDefault [] (Dict.get "countries" newModel.search))
                        >> setFilterText
                            (0 !! (Maybe.withDefault [] (Dict.get "filterText" newModel.search)))

                homeDataCmd =
                    if model.navCount == 0 then
                        HomeDataDecoder.requestCmd newModel
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
                  }
                , Cmd.batch [ homeDataCmd, queryCmd ]
                )

        SubmitLoginEmailForm ->
            ( model, requestLoginCodeCmd model )

        LoginEmailFormOnInput email ->
            ( { model | email = email }, Cmd.none )

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

                { categorySelect, homeData } =
                    model

                newCategoryModel =
                    { categorySelect | options = getCategories homeData selected }

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

        AccordionToggleClick ( id, index ) ->
            let
                accordionIsOpen =
                    Set.member ( id, index ) model.accordionsOpen

                accordionsOpen =
                    if not accordionIsOpen then
                        Set.insert ( id, index ) model.accordionsOpen
                    else
                        Set.remove ( id, index ) model.accordionsOpen
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

        FetchQueryResults (Ok results) ->
            ( { model | queryResults = results.results }, Cmd.none )

        FetchQueryResults (Err _) ->
            ( model, Cmd.none )

        HomeData (Ok results) ->
            let
                { activitySelect, categorySelect, countrySelect } =
                    model

                newActivityModel =
                    { activitySelect | options = getActivities results.taxonomy }

                selected =
                    Maybe.withDefault "" activitySelect.selected

                newCategoryModel =
                    { categorySelect | options = getCategories results.taxonomy selected }

                countriesList =
                    getCountries results.countries

                cs1 =
                    getCountrySelect 0 model

                cs2 =
                    getCountrySelect 1 model

                countriesDict =
                    getCountriesDict results.countries
            in
                ( { model
                    | homeData = results.taxonomy
                    , countries = countriesDict
                    , activitySelect = newActivityModel
                    , categorySelect = newCategoryModel
                    , countrySelect =
                        countrySelect
                            |> Dict.insert 0 { cs1 | countries = countriesList }
                            |> Dict.insert 1 { cs2 | countries = countriesList }
                  }
                , Cmd.none
                )

        HomeData (Err _) ->
            ( model, Cmd.none )

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

                newCountrySelect1 =
                    { countrySelect1 | query = countrySelect2.query }

                newCountrySelect2 =
                    { countrySelect2 | query = "" }

                newCountrySelect =
                    countrySelect
                        |> Dict.insert 0 newCountrySelect1
                        |> Dict.insert 1 newCountrySelect2

                newQueryString =
                    removeFromQueryString location.search ( "countries", index )
            in
                ( { model
                    | countrySelect = newCountrySelect
                  }
                , Navigation.modifyUrl ("/#/query?" ++ newQueryString)
                )

        _ ->
            ( model, Cmd.none )
