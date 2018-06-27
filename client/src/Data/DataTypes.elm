module DataTypes exposing (..)


type alias QueryResults =
    { nMatches : Int
    , totalMatches : Int
    , maxScore : Float
    , matches : List QueryResultsMatch
    }


type alias QueryResultsMatch =
    { score : Float
    , title : String
    , type_ : String
    , country : String
    , year : Maybe Int
    , url : String
    , id : String
    , body : List QueryResultsMatchBody
    }


type alias QueryResultsMatchBody =
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
