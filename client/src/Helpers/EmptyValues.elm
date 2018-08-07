module Helpers.EmptyValues exposing (..)

import DataTypes exposing (QueryResultMatch, QueryResultMatchBody)


emptyQueryResultMatch : QueryResultMatch
emptyQueryResultMatch =
    { title = ""
    , type_ = ""
    , country = ""
    , year = Nothing
    , url = ""
    , id = ""
    , score = 0
    , body = []
    }


emptyQueryResultMatchBody : QueryResultMatchBody
emptyQueryResultMatchBody =
    { tags = []
    , text = ""
    , offset = 0
    , summary = ""
    , url = ""
    , page = 0
    , id = ""
    }
