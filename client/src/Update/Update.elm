module Update exposing (..)

import Model exposing (Model, Msg(..))
import LoginDecoder exposing (requestLoginCodeCmd)
import QueryDecoder
import HomeDataDecoder
import CountrySelect
import ActivitySelect exposing (emptyActivity)
import CategorySelect
import Helpers.Routing exposing (onUrlChange)
import Helpers.HomeData exposing (getActivities, getCategories, getCountries)
import Set


andThen : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
andThen msg ( model, cmd ) =
    let
        ( newmodel, newcmd ) =
            update msg model
    in
        newmodel ! [ cmd, newcmd ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                newModel =
                    onUrlChange location model

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
            in
                ( { newModel | navCount = model.navCount + 1 }, Cmd.batch [ homeDataCmd, queryCmd ] )

        SubmitLoginEmailForm ->
            ( model, requestLoginCodeCmd model )

        LoginEmailFormOnInput email ->
            ( { model | email = email }, Cmd.none )

        SetActiveCategory category ->
            ( { model | activeCategory = category }, Cmd.none )

        CountrySelectMsg subMsg ->
            let
                ( updatedCountrySelectModel, countrySelectCmd ) =
                    CountrySelect.update subMsg model.countrySelect
            in
                ( { model | countrySelect = updatedCountrySelectModel }, Cmd.map CountrySelectMsg countrySelectCmd )

        ActivitySelectMsg subMsg ->
            let
                ( updatedActivitySelectModel, activitySelectCmd ) =
                    ActivitySelect.update subMsg model.activitySelect

                selectedActivity =
                    Maybe.withDefault emptyActivity updatedActivitySelectModel.selectedActivity

                { categorySelect, homeData } =
                    model

                newCategoryModel =
                    { categorySelect | options = getCategories homeData selectedActivity.id }
            in
                ( { model
                    | activitySelect = updatedActivitySelectModel
                    , categorySelect = newCategoryModel
                  }
                , Cmd.map ActivitySelectMsg activitySelectCmd
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
            in
                ( { model | categorySelect = updatedCategorySelectModel }, Cmd.map CategorySelectMsg categorySelectCmd )

        FetchQueryResults (Ok results) ->
            ( { model | queryResults = results }, Cmd.none )

        FetchQueryResults (Err _) ->
            ( model, Cmd.none )

        HomeData (Ok results) ->
            let
                { activitySelect, categorySelect, countrySelect } =
                    model

                newActivityModel =
                    { activitySelect | options = getActivities results.taxonomy }

                selectedActivity =
                    Maybe.withDefault ActivitySelect.emptyActivity activitySelect.selectedActivity

                newCategoryModel =
                    { categorySelect | options = getCategories results.taxonomy selectedActivity.id }

                newCountryModel =
                    { countrySelect | countries = getCountries results.countries }
            in
                ( { model
                    | homeData = results.taxonomy
                    , countries = results.countries
                    , activitySelect = newActivityModel
                    , categorySelect = newCategoryModel
                    , countrySelect = newCountryModel
                  }
                , Cmd.none
                )

        HomeData (Err _) ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
