module Selectors exposing (isLoggedIn)

import Model exposing (Model)


isLoggedIn : Model -> Bool
isLoggedIn model =
    case model.session of
        Just _ ->
            True

        Nothing ->
            False
