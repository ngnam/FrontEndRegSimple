module Selectors exposing (isLoggedIn, isAdmin)

import Model exposing (Model)
import DataTypes exposing (Role(..))


isLoggedIn : Model -> Bool
isLoggedIn model =
    case model.session of
        Just _ ->
            True

        Nothing ->
            False


isAdmin : Model -> Bool
isAdmin model =
    case model.session of
        Just user ->
            case user.role of
                RoleAdmin ->
                    True

                _ ->
                    False

        Nothing ->
            False
