module ActivitySelect exposing (Model, Msg, initialModel, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Util exposing (..)
import ClassNames exposing (classNames)


-- MODEL --


type alias Index =
    Int


type alias Activity =
    { name : String, id : Int }


type alias Model =
    { menuOpen : Bool
    , selected : Index
    , options : List Activity
    }


initialModel : Model
initialModel =
    { menuOpen = False
    , selected = -1
    , options = activities
    }


emptyActivity : Activity
emptyActivity =
    { name = "Choose your activity", id = -1 }


activities : List Activity
activities =
    [ { name = "big long name here", id = 1 }
    , { name = "big long name here2", id = 2 }
    ]


activityMenu : List Activity -> Int -> Bool -> String -> Html Msg
activityMenu activities selected menuIsVisible menuClass =
    div
        [ id "activity-list"
        , class menuClass
        , ariaExpanded (String.toLower (toString menuIsVisible))
        , ariaHidden (not menuIsVisible)
        ]
        (List.indexedMap
            (\index activity ->
                label [ for ("activity-" ++ (toString index)) ]
                    [ input
                        [ type_ "radio"
                        , onClick (SetSelected index)
                        , name "activity"
                        , id ("activity-" ++ (toString index))
                        , class
                            (if index == selected then
                                "active"
                             else
                                ""
                            )
                        ]
                        []
                    , text
                        activity.name
                    ]
            )
            activities
        )


view : Model -> String -> Html Msg
view { menuOpen, selected, options } inputClass =
    let
        menuIsVisible =
            menuOpen

        selectedActivity =
            Maybe.withDefault emptyActivity (selected !! options)

        menuClass =
            classNames
                [ ( "list bottom-0 bg-blue", True )
                , ( "dn", not menuIsVisible )
                , ( "absolute ", menuIsVisible )
                ]
    in
        div
            []
            [ button
                [ onClick
                    HandleButtonClick
                , type_ "button"
                , placeholder "Choose your activity"
                , class inputClass
                , ariaControls "activity-list"
                ]
                [ text selectedActivity.name ]
            , activityMenu
                options
                selected
                menuIsVisible
                menuClass
            ]



-- UPDATE --


type Msg
    = SetSelected Index
    | HandleButtonClick
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSelected selected ->
            ( { model
                | selected = selected
                , menuOpen = not model.menuOpen
              }
            , Cmd.none
            )

        HandleButtonClick ->
            ( { model | menuOpen = not model.menuOpen }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
