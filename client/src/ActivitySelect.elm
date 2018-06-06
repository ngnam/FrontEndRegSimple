module ActivitySelect exposing (Model, Msg, initialModel, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Util exposing (..)


-- MODEL --


type alias Index =
    Int


type alias Activity =
    { name : String, shortName : String, id : Int }


type alias Model =
    { focused : Int
    , hovered : Int
    , menuOpen : Bool
    , selected : Index
    , options : List Activity
    }


initialModel : Model
initialModel =
    { focused = -1
    , hovered = -1
    , menuOpen = False
    , selected = -1
    , options = activities
    }


emptyActivity : Activity
emptyActivity =
    { name = "", shortName = "", id = -1 }


activities : List Activity
activities =
    [ { name = "big long name here", shortName = "BLNH", id = 1 }
    , { name = "big long name here2", shortName = "BLNH2", id = 2 }
    ]


activityMenu : List Activity -> Int -> Bool -> String -> Html Msg
activityMenu activities selected menuIsVisible menuClass =
    div [ id "activity-list", class (menuClass ++ " list bottom-0 bg-blue"), ariaExpanded (String.toLower (toString menuIsVisible)), ariaHidden (not menuIsVisible) ]
        (List.concat
            (List.indexedMap
                (\index activity ->
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
                    , label [ for ("activity-" ++ (toString index)) ] [ text activity.name ]
                    ]
                )
                activities
            )
        )


view : Model -> String -> Html Msg
view { menuOpen, selected, options } inputClass =
    let
        menuIsVisible =
            menuOpen

        selectedActivity =
            Maybe.withDefault emptyActivity (selected !! options)

        menuClass =
            if menuIsVisible then
                "absolute"
            else
                "dn"
    in
        div
            []
            [ button
                [ onClick
                    ToggleMenu
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
    | ToggleMenu
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

        ToggleMenu ->
            ( { model | menuOpen = not model.menuOpen }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
