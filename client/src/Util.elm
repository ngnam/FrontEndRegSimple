module Util exposing (boolStr, (!!), viewIf)

import Html exposing (Html)


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
