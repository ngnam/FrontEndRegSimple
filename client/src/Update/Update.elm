port module Update exposing (..)

import Model exposing (Model, Msg(..), initialModel, initialSnippetFeedback)
import Debouncer
import Navigation
import LoginEmailDecoder
import LoginCodeDecoder
import LogoutDecoder
import QueryDecoder
import AppDataDecoder
import CountrySelect
import ActivitySelect
import CategorySelect
import Helpers.Routing exposing (onUrlChange)
import Helpers.QueryString exposing (queryString, removeFromQueryString)
import Helpers.AppData exposing (getActivities, getCategories, getCountries, getCountriesDict)
import Helpers.CountrySelect exposing (getCountrySelect, getSelectedCountry)
import Set
import Dict
import Util exposing ((!!))
import DataTypes exposing (Taxonomy, emptyTaxonomy, CountryId, CategoryId, FeedbackType(..), User, ActivityId, SnippetFeedback)
import RemoteData exposing (RemoteData(..), WebData)
import DictList
import FeedbackDecoder
import BookmarksDecoder
import Ports exposing (copy)
import Json.Encode exposing (encode, null)
import Encoders
import Tuple


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
                    Just (String.toUpper id)

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


toggleCategoryFeedbackSelected : CategoryId -> SnippetFeedback -> List CategoryId
toggleCategoryFeedbackSelected categoryId model =
    let
        alreadySelected =
            List.member categoryId model.categoryIds

        exclude option el =
            option /= el
    in
        if alreadySelected then
            List.filter (exclude categoryId) model.categoryIds
        else
            model.categoryIds ++ [ categoryId ]


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


storeSession : Model -> Cmd msg
storeSession model =
    let
        { user, snippetBookmarks } =
            model

        session =
            { user = user
            , snippetBookmarks = snippetBookmarks
            }
    in
        Encoders.session session
            |> encode 0
            |> Just
            |> Ports.storeSession


removeSession : Cmd msg
removeSession =
    Ports.storeSession Nothing


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
                        Cmd.batch
                            [ AppDataDecoder.requestCmd newModel
                            , BookmarksDecoder.getRequestCmd
                                newModel
                            ]
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
            ( { model | loginEmail = email }, Cmd.none )

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
                , user =
                    case response of
                        Success user ->
                            Just user

                        _ ->
                            Nothing
              }
            , case response of
                Success user ->
                    Cmd.batch [ Navigation.modifyUrl "/#/", storeSession ({ model | user = Just user }), BookmarksDecoder.getRequestCmd model ]

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

        CategoryOptionsMenuSetFocus maybeCategoryId ->
            ( { model | categorySubMenuOpen = maybeCategoryId }, Cmd.none )

        SnippetOptionsMenuSetFocus maybeSnippetId ->
            ( { model | snippetOptionsMenuOpen = maybeSnippetId }, Cmd.none )

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

        SnippetFeedbackDialogOpenClick snippetData ->
            let
                { snippetFeedback } =
                    model

                newSnippetFeedbackModel =
                    { snippetFeedback | dialogOpen = True, snippetData = snippetData }
            in
                ( { model | snippetFeedback = newSnippetFeedbackModel }, Cmd.none )

        SnippetFeedbackDialogCloseClick ->
            let
                { snippetFeedback } =
                    model

                newSnippetFeedbackModel =
                    { snippetFeedback | dialogOpen = False, snippetData = Nothing }
            in
                ( { model | snippetFeedback = newSnippetFeedbackModel }, Cmd.none )

        ActivityFeedbackClick activityId ->
            let
                { snippetFeedback } =
                    model

                newSnippetFeedbackModel =
                    { snippetFeedback | activityId = activityId, activityMenuOpen = False }
            in
                ( { model | snippetFeedback = newSnippetFeedbackModel }, Cmd.none )

        ActivityMenuFeedbackToggleClick ->
            let
                { snippetFeedback } =
                    model

                newSnippetFeedbackModel =
                    { snippetFeedback | activityMenuOpen = not snippetFeedback.activityMenuOpen, categoryMenuOpen = False }
            in
                ( { model | snippetFeedback = newSnippetFeedbackModel }, Cmd.none )

        CategoryFeedbackClick categoryId ->
            let
                { snippetFeedback } =
                    model

                newSnippetCategories =
                    toggleCategoryFeedbackSelected categoryId snippetFeedback

                newSnippetFeedbackModel =
                    { snippetFeedback | categoryIds = newSnippetCategories, categoryMenuOpen = (List.length newSnippetCategories) < 2 }
            in
                ( { model | snippetFeedback = newSnippetFeedbackModel }, Cmd.none )

        CategoryMenuFeedbackToggleClick ->
            let
                { snippetFeedback } =
                    model

                newSnippetFeedbackModel =
                    { snippetFeedback | categoryMenuOpen = not snippetFeedback.categoryMenuOpen, activityMenuOpen = False }
            in
                ( { model | snippetFeedback = newSnippetFeedbackModel }, Cmd.none )

        SnippetBookmarkClick snippetBookmarkKey isBookmarked ->
            case isBookmarked of
                True ->
                    ( model, BookmarksDecoder.deleteRequestCmd model snippetBookmarkKey )

                False ->
                    ( model, BookmarksDecoder.postRequestCmd model snippetBookmarkKey )

        SnippetBookmarkAdd snippetBookmarkKey snippetBookmarkMetadata ->
            let
                snippetBookmarks =
                    DictList.cons snippetBookmarkKey snippetBookmarkMetadata model.snippetBookmarks

                newModel =
                    { model | snippetBookmarks = snippetBookmarks }
            in
                ( { model | snippetBookmarks = snippetBookmarks }, storeSession newModel )

        SnippetBookmarkRemove snippetBookmarkKey ->
            let
                snippetBookmarks =
                    DictList.remove snippetBookmarkKey model.snippetBookmarks

                newModel =
                    { model | snippetBookmarks = snippetBookmarks }
            in
                ( { model | snippetBookmarks = snippetBookmarks }, storeSession newModel )

        SnippetBookmarksHydrate snippetBookmarks ->
            let
                newModel =
                    { model | snippetBookmarks = snippetBookmarks }
            in
                ( newModel, storeSession newModel )

        QueryResultListRemoveClick categoryCountry ->
            let
                { location, countrySelect } =
                    model

                countrySelect1 =
                    getCountrySelect 0 model

                countrySelect2 =
                    getCountrySelect 1 model

                countryId =
                    Tuple.second categoryCountry

                newCountrySelect =
                    if countrySelect1.selected == Just countryId then
                        countrySelect
                            |> Dict.insert 0 { countrySelect1 | query = countrySelect2.query }
                            |> Dict.insert 1 { countrySelect2 | query = "" }
                    else
                        countrySelect
                            |> Dict.insert 1 { countrySelect2 | query = "" }

                newQueryString =
                    removeFromQueryString location.search ( "countries", countryId )
            in
                ( { model
                    | countrySelect = newCountrySelect
                  }
                , Navigation.modifyUrl ("/#/query?" ++ newQueryString)
                )

        SnippetSuggestClick snippetFeedbackData ->
            case snippetFeedbackData of
                Nothing ->
                    ( model, Cmd.none )

                Just ( snippetId, categoryCountry ) ->
                    let
                        modifiedQueryResults =
                            case model.queryResults of
                                Success queryResults ->
                                    Success <|
                                        DictList.map
                                            (\categoryCountry_ result ->
                                                if categoryCountry_ == categoryCountry then
                                                    removeSnippetFromResults snippetId result
                                                else
                                                    result
                                            )
                                            queryResults

                                _ ->
                                    model.queryResults
                    in
                        ( { model
                            | queryResults = modifiedQueryResults
                            , snippetFeedback = initialSnippetFeedback
                          }
                        , FeedbackDecoder.requestCmd
                            model
                            (SnippetSuggest ( snippetId, model.snippetFeedback.categoryIds ))
                        )

        SnippetVoteUpClick snippetCategory ->
            ( model, FeedbackDecoder.requestCmd model <| SnippetVoteUp snippetCategory )

        SnippetVoteDownClick snippetCategory ->
            ( model, FeedbackDecoder.requestCmd model <| SnippetVoteDown snippetCategory )

        FeedbackRequest feedbackType results ->
            ( { model | snippetOptionsMenuOpen = Nothing }
            , Cmd.none
            )

        LogoutClick ->
            ( model, LogoutDecoder.requestCmd model )

        LogoutOnResponse response ->
            ( { initialModel
                | config = model.config
                , appData = model.appData
              }
            , Cmd.batch [ removeSession, Navigation.modifyUrl "/#/" ]
            )

        _ ->
            ( model, Cmd.none )
