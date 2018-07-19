module Util exposing (boolStr, (!!), viewIf, toKeyValuePair, toDict, indexOf, toDictList)

import Html exposing (Attribute, Html)
import Dict exposing (Dict)
import DictList
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


indexOf : a -> List a -> Int
indexOf el list =
    let
        indexOf_ list_ index =
            case list_ of
                [] ->
                    -1

                x :: xs ->
                    if x == el then
                        index
                    else
                        indexOf_ xs (index + 1)
    in
        indexOf_ list 0



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


toDict : List ( comparable, a ) -> Dict comparable (List a)
toDict values =
    let
        append v mv =
            Just (v :: Maybe.withDefault [] mv)

        foldF ( k, v ) acc =
            Dict.update k (append v) acc
    in
        List.foldr foldF Dict.empty values


toDictList values =
    DictList.fromDict (toDict values)


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
