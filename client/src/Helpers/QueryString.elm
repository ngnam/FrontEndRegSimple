module Helpers.QueryString exposing (queryString)

import Model exposing (Model)
import Dict


queryString : Model -> String
queryString model =
    let
        countries =
            "countries[]="
                ++ Maybe.withDefault "" model.countrySelect.selected

        activity =
            "&activity[]="
                ++ Maybe.withDefault "" model.activitySelect.selected

        categories =
            List.foldr (\categoryId accum -> accum ++ "&categories[]=" ++ categoryId) "" model.categorySelect.selected
    in
        countries ++ activity ++ categories
