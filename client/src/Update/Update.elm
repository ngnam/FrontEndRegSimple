module Update exposing (..)

import Types exposing (..)
import LoginDecoder exposing (requestLoginCodeCmd)
import QueryDecoder exposing (fetchQueryResultsCmd)
import ComponentDataDecoder exposing (fetchComponentDataCmd)
import CountrySelect
import ActivitySelect exposing (emptyActivity)
import CategorySelect
import Router exposing (onUrlChange)
import Helpers.ComponentData exposing (getActivities, getCategories)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                newModel =
                    onUrlChange location model

                cmd =
                    case newModel.location.hash of
                        "#/query" ->
                            fetchQueryResultsCmd newModel

                        "#/" ->
                            fetchComponentDataCmd newModel

                        _ ->
                            Cmd.none
            in
                ( newModel, cmd )

        SubmitLoginEmailForm ->
            ( model, requestLoginCodeCmd model )

        LoginEmailFormOnInput email ->
            ( { model | email = email }, Cmd.none )

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

                { categorySelect, componentData } =
                    model

                newCategoryModel =
                    { categorySelect | options = getCategories componentData selectedActivity.id }
            in
                ( { model
                    | activitySelect = updatedActivitySelectModel
                    , categorySelect = newCategoryModel
                  }
                , Cmd.map ActivitySelectMsg activitySelectCmd
                )

        CategorySelectMsg subMsg ->
            let
                ( updatedCategorySelectModel, categorySelectCmd ) =
                    CategorySelect.update subMsg model.categorySelect
            in
                ( { model | categorySelect = updatedCategorySelectModel }, Cmd.map CategorySelectMsg categorySelectCmd )

        QueryResults (Ok results) ->
            ( { model | queryResults = results }, Cmd.none )

        QueryResults (Err _) ->
            ( model, Cmd.none )

        ComponentData (Ok results) ->
            let
                { activitySelect, categorySelect } =
                    model

                newActivityModel =
                    { activitySelect | options = getActivities results }

                selectedActivity =
                    Maybe.withDefault ActivitySelect.emptyActivity activitySelect.selectedActivity

                newCategoryModel =
                    { categorySelect | options = getCategories results selectedActivity.id }
            in
                ( { model
                    | componentData = results
                    , activitySelect = newActivityModel
                    , categorySelect = newCategoryModel
                  }
                , Cmd.none
                )

        ComponentData (Err _) ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
