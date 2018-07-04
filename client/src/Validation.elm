module Validation exposing (Validation(..))


type alias Msg =
    String


type Validation
    = Valid
    | Invalid Msg
