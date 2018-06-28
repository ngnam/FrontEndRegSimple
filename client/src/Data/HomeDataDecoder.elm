module HomeDataDecoder exposing (requestCmd)

import Model exposing (Model, Msg(..))
import DataTypes exposing (HomeDataResults, Taxonomy, HomeDataChildren(..))
import CountrySelect exposing (CountryId, CountryName)
import Http
import Json.Decode
    exposing
        ( Decoder
        , string
        , bool
        , null
        , list
        , lazy
        , field
        , map
        , map4
        , at
        , oneOf
        , nullable
        , keyValuePairs
        , map2
        )
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


taxonomyDecoder : Decoder Taxonomy
taxonomyDecoder =
    decode Taxonomy
        |> optional "id" string ""
        |> required "enabled" bool
        |> optional "name" string ""
        |> optional "description" string ""
        |> required "children" (map HomeDataChildren (list (lazy (\_ -> taxonomyDecoder))))


countriesDecoder : Decoder (List ( CountryId, List CountryName ))
countriesDecoder =
    keyValuePairs (list string)


nullableString : Decoder String
nullableString =
    oneOf [ string, null "" ]


decoder : Decoder HomeDataResults
decoder =
    decode HomeDataResults
        |> required "taxonomy" taxonomyDecoder
        |> required "countries" countriesDecoder


request : Model -> Http.Request HomeDataResults
request model =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Content-Type" "application/json" ]
        , url = model.config.apiBaseUrl ++ "/home-data"
        , body = Http.emptyBody
        , expect = Http.expectJson (at [ "data" ] decoder)
        , timeout = Nothing
        , withCredentials = False
        }


requestCmd : Model -> Cmd Msg
requestCmd model =
    Http.send HomeData (request model)
