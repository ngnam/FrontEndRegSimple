module AppDataDecoder exposing (requestCmd)

import Model exposing (Model, Msg(..))
import DataTypes exposing (AppDataResults, Taxonomy, AppDataChildren(..), CountryId, CountryName, CountriesDictList)
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
import RemoteData
import DictList exposing (decodeObject)


taxonomyDecoder : Decoder Taxonomy
taxonomyDecoder =
    decode Taxonomy
        |> optional "id" string ""
        |> required "enabled" bool
        |> optional "name" string ""
        |> optional "description" string ""
        |> required "children" (map AppDataChildren (list (lazy (\_ -> taxonomyDecoder))))



-- countriesDecoder : Decoder (List ( CountryId, List CountryName ))
-- countriesDecoder =
--     keyValuePairs (list string)


countriesDecoder : Decoder CountriesDictList
countriesDecoder =
    decodeObject (list string)


nullableString : Decoder String
nullableString =
    oneOf [ string, null "" ]


decoder : Decoder AppDataResults
decoder =
    decode AppDataResults
        |> required "taxonomy" taxonomyDecoder
        |> required "countries" countriesDecoder


request : Model -> Http.Request AppDataResults
request model =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Content-Type" "application/json" ]
        , url = model.config.apiBaseUrl ++ "/app-data"
        , body = Http.emptyBody
        , expect = Http.expectJson (at [ "data" ] decoder)
        , timeout = Nothing
        , withCredentials = False
        }


requestCmd : Model -> Cmd Msg
requestCmd model =
    request model
        |> RemoteData.sendRequest
        |> Cmd.map FetchAppData
