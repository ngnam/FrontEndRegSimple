module Update exposing (..)

import Types exposing (..)
import LoginDecoder exposing (requestLoginCodeCmd)
import QueryDecoder exposing (fetchQueryResultsCmd)
import CountrySelect
import ActivitySelect
import CategorySelect
import Http
import Router exposing (onUrlChange)


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
            in
                ( { model | activitySelect = updatedActivitySelectModel }, Cmd.map ActivitySelectMsg activitySelectCmd )

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

        _ ->
            ( model, Cmd.none )
