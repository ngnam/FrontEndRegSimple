module ActivitySelect exposing (Model, Msg, initialModel, update, view, Activity, ActivityId)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Util exposing (..)
import Json.Decode as Json
import DataTypes exposing (HomeDataItem)


-- MODEL --


type alias Index =
    Int


type alias ActivityId =
    String


type alias Activity =
    HomeDataItem


type alias Config =
    { inputAlignment : String, inputSize : String }


type alias Model =
    { menuOpen : Bool
    , hovered : Index
    , focused : Index
    , options : List Activity
    , selected : Maybe ActivityId
    }


initialModel : Model
initialModel =
    { menuOpen = False
    , hovered = -1
    , focused = -1
    , options = []
    , selected = Nothing
    }


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


activityMenu : Model -> Attribute Msg -> Html Msg
activityMenu model menuClass =
    let
        { options, selected, menuOpen } =
            model
    in
        div
            [ id "activity-list"
            , menuClass
            , ariaExpanded (boolStr menuOpen)
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
                            classList
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
                            [ labelClass
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
                                    [ classList
                                        [ ( "absolute w-75 h-75 bg-blue br-100"
                                          , Just activity.id == selected
                                          )
                                        ]
                                    ]
                                    []
                                ]
                            , input
                                [ type_ "radio"
                                , onClick (SetSelected activity.id)
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


view : Model -> Config -> Html Msg
view model { inputAlignment, inputSize } =
    let
        { selected, menuOpen, options } =
            model

        menuClass =
            classList
                [ ( "list bg-white ttc w30rem top-150 ba b--gray shadow-1 pv2 ph0", True )
                , ( "absolute z-4 flex flex-wrap justify-between", menuOpen )
                , ( "dn", not menuOpen )
                , ( "translate-center", inputAlignment /= "left" )
                ]

        wrapperClass =
            classList
                [ ( "relative fl", True )
                , ( "mr2", inputAlignment == "left" )
                , ( "w-30", inputSize /= "small" )
                , ( "w-20", inputSize == "small" )
                ]

        buttonClass =
            classList
                [ ( "arrows w-100 h2 fl pv2 ph3 br-pill ba b--solid b--blue tl truncate bg-white b", True )
                , ( "bg-blue white arrows--white", menuOpen )
                , ( "arrows--blue", not menuOpen )
                , ( "dark-gray", selected == Nothing )
                ]

        buttonUnderlineClass =
            "absolute top-125 w-100 ba b--blue"
    in
        div
            [ wrapperClass, onKeyDown model ]
            [ button
                [ onBlur HandleButtonBlur
                , onFocus HandleButtonFocus
                , onKeyDown model
                , type_ "button"
                , type_ "button"
                , buttonClass
                , ariaControls "activity-list"
                ]
                [ text (getActivityName selected options) ]
            , viewIf menuOpen (div [ class buttonUnderlineClass ] [])
            , activityMenu
                model
                menuClass
            ]


getActivityName : Maybe ActivityId -> List Activity -> String
getActivityName maybeId activities =
    let
        defaultButtonText =
            "Choose an Activity"
    in
        case maybeId of
            Just id ->
                activities
                    |> List.filter (\activity -> activity.id == id)
                    |> List.head
                    |> Maybe.map .name
                    |> Maybe.withDefault defaultButtonText

            Nothing ->
                defaultButtonText


getActivityId : Index -> List Activity -> ActivityId
getActivityId index activities =
    case index !! activities of
        Just activity ->
            activity.id

        Nothing ->
            ""



-- UPDATE --


type Msg
    = SetSelected ActivityId
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


setSelected : ActivityId -> Model -> Model
setSelected activityId model =
    let
        { options } =
            model
    in
        { model
            | selected = Just activityId
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSelected activityId ->
            let
                withSelected =
                    setSelected activityId model
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
            ( setSelected (getActivityId model.focused model.options) model, Cmd.none )

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
