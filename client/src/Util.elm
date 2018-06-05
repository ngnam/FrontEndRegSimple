module Util exposing (boolStr, (!!))


(!!) : Int -> List a -> Maybe a
(!!) index list =
    if (List.length list) >= index + 1 then
        List.take (index + 1) list
            |> List.reverse
            |> List.head
    else
        Nothing


boolStr : Bool -> String
boolStr bool =
    toString bool
        |> String.toLower
