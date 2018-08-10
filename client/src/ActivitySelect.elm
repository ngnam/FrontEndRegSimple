module ActivitySelect exposing (Model, Msg, initialModel, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Util exposing (..)
import Json.Decode as Json
import DataTypes exposing (AppDataItem, InputAlignment(..), Activity, ActivityId, Index)
import Helpers.AppData exposing (getActivityName)


-- MODEL --


type alias Config =
    { inputAlignment : InputAlignment, loadingButtonInner : Maybe (Html Msg) }


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
        fieldset
            [ id "activity-list"
            , menuClass
            , ariaExpanded (boolStr menuOpen)
            , ariaHidden (not menuOpen)
            , onFocus HandleMenuFocus
            , onBlur HandleMenuBlur
            , tabindex -1
            ]
            (legend
                [ class "clip" ]
                [ text "Please select from the following activities (required)" ]
                :: (List.indexedMap
                        (\index activity ->
                            let
                                isDisabled =
                                    not activity.enabled

                                labelClass =
                                    classList
                                        [ ( "relative fl pl4 pt1 pb2 w-50 tl f6"
                                          , True
                                          )
                                        , ( "dn"
                                          , isDisabled
                                          )
                                        , ( "pointer db"
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
                                        , required True
                                        ]
                                        []
                                    , div [ class "ml2" ] [ text activity.name ]
                                    ]
                        )
                        options
                   )
            )


view : Model -> Config -> Html Msg
view model { inputAlignment, loadingButtonInner } =
    let
        { selected, menuOpen, options } =
            model

        menuClass =
            classList
                [ ( "list bg-white ttc w30rem top-150 ba b--light-gray shadow-1 pv2 ph0 absolute z-4 dropdown-menu", True )
                , ( "dn", not menuOpen )
                , ( "translate-center", inputAlignment == Center )
                ]

        wrapperClass =
            classList
                [ ( "relative fl w-100", True ) ]

        buttonClass =
            classList
                [ ( "w-100 h2 fl pv2 pl3 pr4 br-pill ba b--solid b--blue tl truncate bg-white b icon icon--input-arrows", True )
                , ( "bg-blue white icon--input-arrows-white", menuOpen )
                , ( "icon--input-arrows-blue", not menuOpen )
                , ( "dark-gray", selected == Nothing )
                ]

        buttonUnderlineClass =
            "absolute top-125 w-100 ba b--blue"

        buttonInner =
            case loadingButtonInner of
                Just el ->
                    el

                _ ->
                    text (getActivityName selected options)
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
                [ buttonInner ]
            , viewIf menuOpen (div [ class buttonUnderlineClass ] [])
            , activityMenu
                model
                menuClass
            ]


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
