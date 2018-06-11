module Update exposing (..)

import Types exposing (..)
import LoginDecoder exposing (requestLoginCodeCmd)
import CountrySelect
import ActivitySelect
import CategorySelect


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            { model | location = location } ! []

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

        _ ->
            ( model, Cmd.none )
