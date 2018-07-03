module DataTypes exposing (..)

import Dict


type alias SearchParsed =
    Dict.Dict String (List String)


type alias QueryResults =
    { results : List QueryResult }


type alias QueryResult =
    { nMatches : Int
    , totalMatches : Int
    , maxScore : Maybe Float
    , matches : List QueryResultMatch
    }


type alias QueryResultMatch =
    { score : Float
    , title : String
    , type_ : String
    , country : String
    , year : Maybe Int
    , url : String
    , id : String
    , body : List QueryResultMatchBody
    }


type alias QueryResultMatchBody =
    { tags : List String
    , text : String
    , offset : Int
    , summary : String
    , url : String
    , page : Int
    }


type alias HomeDataResults =
    { taxonomy : Taxonomy
    , countries : List ( String, List String )
    }


type alias TaxonomyId =
    String


type alias Taxonomy =
    { id : TaxonomyId
    , enabled : Bool
    , name : String
    , description : String
    , children : HomeDataChildren
    }


type alias HomeDataItem =
    { id : TaxonomyId
    , enabled : Bool
    , name : String
    , description : String
    }


type HomeDataChildren
    = HomeDataChildren (List Taxonomy)
