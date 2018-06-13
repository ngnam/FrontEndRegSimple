module ActivitySelect exposing (Model, Msg, initialModel, update, view, Activity, ActivityId, emptyActivity)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Util exposing (..)
import ClassNames exposing (classNames)
import Json.Decode as Json


-- MODEL --


type alias Index =
    Int


type alias ActivityId =
    String


type alias Activity =
    { name : String, id : ActivityId, enabled : Bool }


type alias Options =
    { inputAlignment : String }


type alias Model =
    { menuOpen : Bool
    , hovered : Index
    , focused : Index
    , selected : Index
    , options : List Activity
    , selectedActivity : Maybe Activity
    }


initialModel : Model
initialModel =
    { menuOpen = False
    , hovered = -1
    , focused = -1
    , selected = -1
    , options = []
    , selectedActivity = Nothing
    }


emptyActivity : Activity
emptyActivity =
    { name = "Choose your activity", id = "-1", enabled = True }


onKeyDown : Model -> Attribute Msg
onKeyDown model =
    let
        options =
            { defaultOptions | preventDefault = True }

        filterKey code =
            if code == 13 then
                Json.succeed HandleEnter
            else if code == 27 then
                Json.succeed HandleEscape
            else
                Json.fail "ignored input"

        decoder =
            Html.Events.keyCode
                |> Json.andThen filterKey
    in
        onWithOptions "keydown" options decoder


activityMenu : Model -> String -> Html Msg
activityMenu model menuClass =
    let
        { options, selected, menuOpen } =
            model
    in
        div
            [ id "activity-list"
            , class menuClass
            , ariaExpanded (String.toLower (toString menuOpen))
            , ariaHidden (not menuOpen)
            , onFocus HandleMenuFocus
            , onBlur HandleMenuBlur
            , tabindex -1
            ]
            (List.indexedMap
                (\index activity ->
                    let
                        isDisabled =
                            not activity.enabled

                        labelClass =
                            classNames
                                [ ( "relative pl4 pt1 pb2 w-50 tl f6"
                                  , True
                                  )
                                , ( "o-30"
                                  , isDisabled
                                  )
                                , ( "pointer"
                                  , not isDisabled
                                  )
                                ]

                        tabable =
                            if isDisabled then
                                -1
                            else
                                0
                    in
                        label
                            [ class labelClass
                            , for ("activity-" ++ (toString index))
                            , tabindex tabable
                            , onFocus (HandleOptionFocused index)
                            , onBlur HandleOptionBlur
                            , onMouseEnter (HandleOptionHovered index)
                            , onKeyDown
                                model
                            ]
                            [ div
                                [ class
                                    "absolute left-1 w1 h1 br-100 bg-white b--blue ba fl flex flex-column justify-center items-center mr1"
                                ]
                                [ div
                                    [ class
                                        (classNames
                                            [ ( "absolute w-75 h-75 bg-blue br-100", index == selected ) ]
                                        )
                                    ]
                                    []
                                ]
                            , input
                                [ type_ "radio"
                                , onClick (SetSelected index)
                                , name "activity"
                                , disabled isDisabled
                                , tabindex -1
                                , id ("activity-" ++ (toString index))
                                , class "clip"
                                ]
                                []
                            , div [ class "ml2" ] [ text activity.name ]
                            ]
                )
                options
            )


view : Model -> Options -> Html Msg
view model { inputAlignment } =
    let
        { selected, selectedActivity, menuOpen } =
            model

        menuClass =
            classNames
                [ ( "list bg-white ttc w30rem top-150 ba b--gray shadow-1 pv2 ph0", True )
                , ( "absolute flex flex-wrap justify-between", menuOpen )
                , ( "dn", not menuOpen )
                , ( "translate-center", inputAlignment /= "left" )
                ]

        wrapperClass =
            classNames
                [ ( "relative w-30 fl", True )
                , ( "mr2", inputAlignment == "left" )
                ]

        buttonClass =
            "w-100 h2 fl pv2 ph3 br-pill ba b--solid b--blue"
                ++ " tl truncate bg-white "
                ++ classNames
                    [ ( "bg-blue white", menuOpen )
                    , ( "black-60", selected == -1 )
                    ]

        buttonUnderlineClass =
            "absolute top-125 w-100 ba b--blue"
    in
        div
            [ class wrapperClass, onKeyDown model ]
            [ button
                [ onBlur HandleButtonBlur
                , onFocus HandleButtonFocus
                , onKeyDown model
                , type_ "button"
                , type_ "button"
                , placeholder "Choose your activity"
                , class buttonClass
                , ariaControls "activity-list"
                ]
                [ text (.name (Maybe.withDefault emptyActivity selectedActivity)) ]
            , viewIf menuOpen (div [ class buttonUnderlineClass ] [])
            , activityMenu
                model
                menuClass
            ]



-- UPDATE --


type Msg
    = SetSelected Index
    | HandleButtonBlur
    | HandleButtonFocus
    | HandleEscape
    | HandleOptionBlur
    | HandleOptionFocused Index
    | HandleOptionHovered Index
    | HandleMenuFocus
    | HandleMenuBlur
    | HandleEnter
    | NoOp


setSelected : Index -> Model -> Model
setSelected index model =
    let
        { options } =
            model

        selectedActivity =
            index !! options
    in
        { model
            | selected = index
            , selectedActivity = selectedActivity
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSelected selected ->
            let
                withSelected =
                    setSelected selected model
            in
                ( { withSelected | menuOpen = False }, Cmd.none )

        HandleOptionBlur ->
            ( { model | focused = -1, menuOpen = False }, Cmd.none )

        HandleOptionFocused index ->
            ( { model | focused = index, menuOpen = True }, Cmd.none )

        HandleOptionHovered index ->
            ( { model | hovered = index }, Cmd.none )

        HandleEscape ->
            ( { model | menuOpen = False }, Cmd.none )

        HandleEnter ->
            ( setSelected model.focused model, Cmd.none )

        HandleButtonBlur ->
            ( { model | menuOpen = False }, Cmd.none )

        HandleButtonFocus ->
            ( { model | menuOpen = True }, Cmd.none )

        HandleMenuBlur ->
            ( { model | menuOpen = False }, Cmd.none )

        HandleMenuFocus ->
            ( { model | menuOpen = True }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
