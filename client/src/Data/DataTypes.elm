module DataTypes exposing (..)

import Dict exposing (Dict)
import DictList exposing (DictList)
import Set exposing (Set)


type InputAlignment
    = Left
    | Right
    | Center


type alias AccordionsOpen =
    Set ( String, Int )


type alias CountryId =
    String


type alias CountryName =
    String


type alias CountriesDictList =
    DictList CountryId (List CountryName)


type alias AppData =
    { countries : CountriesDictList, taxonomy : Taxonomy }


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


type alias AppDataResults =
    { taxonomy : Taxonomy
    , countries : CountriesDictList
    }


type alias TaxonomyId =
    String


type alias Taxonomy =
    { id : TaxonomyId
    , enabled : Bool
    , name : String
    , description : String
    , children : AppDataChildren
    }


emptyTaxonomy : Taxonomy
emptyTaxonomy =
    { id = ""
    , enabled = False
    , name = ""
    , description = ""
    , children = AppDataChildren []
    }


type alias AppDataItem =
    { id : TaxonomyId
    , enabled : Bool
    , name : String
    , description : String
    }


type AppDataChildren
    = AppDataChildren (List Taxonomy)
