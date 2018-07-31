module Helpers.Session exposing (isLoggedIn, isMinRole, roles)

import Util exposing (indexOf)
import DataTypes exposing (Role(..), User)
import DictList exposing (DictList)


roles : DictList String Role
roles =
    DictList.fromList
        [ ( "ROLE_USER", RoleUser )
        , ( "ROLE_EDITOR", RoleEditor )
        , ( "ROLE_ADMIN", RoleAdmin )
        ]


isLoggedIn : Maybe User -> Bool
isLoggedIn user =
    case user of
        Just _ ->
            True

        Nothing ->
            False


isMinRole : Role -> Maybe User -> Bool
isMinRole minRole user =
    let
        rolesList =
            DictList.toList roles
                |> List.map (\( _, el ) -> el)
    in
        case user of
            Just user ->
                indexOf minRole rolesList <= indexOf user.role rolesList

            Nothing ->
                False
