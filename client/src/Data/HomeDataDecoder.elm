module HomeDataDecoder exposing (requestCmd)

import Model exposing (Model, Msg(..))
import DataTypes exposing (HomeDataResults, Taxonomy, HomeDataChildren(..))
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


taxonomyDecoder : Decoder Taxonomy
taxonomyDecoder =
    map4 Taxonomy
        (field "id" nullableString)
        (field "enabled" bool)
        (field "name" nullableString)
        (field "children" (map HomeDataChildren (list (lazy (\_ -> taxonomyDecoder)))))


countriesDecoder : Decoder (List ( String, List String ))
countriesDecoder =
    keyValuePairs (list string)


nullableString : Decoder String
nullableString =
    oneOf [ string, null "" ]


decoder : Decoder HomeDataResults
decoder =
    map2 HomeDataResults
        (field "taxonomy" taxonomyDecoder)
        (field "countries" countriesDecoder)


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
