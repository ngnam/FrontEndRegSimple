module Util exposing (boolStr, (!!), viewIf, parseParams)

import Html exposing (Attribute, Html)
import Dict exposing (Dict)
import Http


-- (!!) is a getter for lists --


(!!) : Int -> List a -> Maybe a
(!!) index list =
    if (List.length list) >= index + 1 then
        List.take (index + 1) list
            |> List.reverse
            |> List.head
    else
        Nothing



-- boolStr converts True to "true" and False to "false"--


boolStr : Bool -> String
boolStr bool =
    toString bool
        |> String.toLower



-- from https://github.com/rtfeldman/elm-spa-example/blob/master/src/Util.elm --


viewIf : Bool -> Html msg -> Html msg
viewIf condition content =
    if condition then
        content
    else
        Html.text ""


parseParams : String -> Dict String (List String)
parseParams queryString =
    queryString
        |> String.dropLeft 1
        |> String.split "&"
        |> List.filterMap toKeyValuePair
        |> toDict


toDict values =
    let
        append v mv =
            Just (v :: Maybe.withDefault [] mv)

        foldF ( k, v ) acc =
            Dict.update k (append v) acc
    in
        List.foldr foldF Dict.empty values


removeBrackets : String -> String
removeBrackets string =
    String.split "[]" string
        |> List.head
        |> Maybe.withDefault ""


toKeyValuePair : String -> Maybe ( String, String )
toKeyValuePair segment =
    case String.split "=" segment of
        [ key, value ] ->
            Maybe.map2 (,) (Http.decodeUri (removeBrackets key)) (Http.decodeUri value)

        _ ->
            Nothing
