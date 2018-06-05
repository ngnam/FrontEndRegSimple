module Update exposing (..)

import Types exposing (..)
import LoginDecoder exposing (requestLoginCodeCmd)
import CountrySelect


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitLoginEmailForm ->
            ( model, requestLoginCodeCmd model )

        LoginEmailFormOnInput email ->
            ( { model | email = email }, Cmd.none )

        CountryOnInput country ->
            ( { model | countryInputValue = country }, Cmd.none )

        CountrySelectMsg subMsg ->
            let
                ( updatedCountrySelectModel, countrySelectCmd ) =
                    CountrySelect.update subMsg model.countrySelect
            in
                ( { model | countrySelect = updatedCountrySelectModel }, Cmd.map CountrySelectMsg countrySelectCmd )

        _ ->
            ( model, Cmd.none )
