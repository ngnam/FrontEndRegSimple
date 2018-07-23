module Helpers.Session exposing (isLoggedIn, isMinRole, roles)

import Util exposing (indexOf)
import DataTypes exposing (Role(..), Session)
import DictList exposing (DictList)


roles : DictList String Role
roles =
    DictList.fromList
        [ ( "ROLE_USER", RoleUser )
        , ( "ROLE_EDITOR", RoleEditor )
        , ( "ROLE_ADMIN", RoleAdmin )
        ]


isLoggedIn : Session -> Bool
isLoggedIn session =
    case session of
        Just _ ->
            True

        Nothing ->
            False


isMinRole : Role -> Session -> Bool
isMinRole minRole session =
    let
        rolesList =
            DictList.toList roles
                |> List.map (\( _, el ) -> el)
    in
        case session of
            Just user ->
                indexOf minRole rolesList <= indexOf user.role rolesList

            Nothing ->
                False
