module DataTypes exposing (..)


type alias QueryResults =
    { data : String }


type alias HomeDataResults =
    { taxonomy : Taxonomy
    , countries : List ( String, List String )
    }


type alias Taxonomy =
    { id : String
    , enabled : Bool
    , name : String
    , children : HomeDataChildren
    }


type alias HomeDataItem =
    { id : String
    , enabled : Bool
    , name : String
    }


type HomeDataChildren
    = HomeDataChildren (List Taxonomy)
