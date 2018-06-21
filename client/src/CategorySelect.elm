module CategorySelect exposing (Model, Msg, Category, emptyCategory, initialModel, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import ClassNames exposing (classNames)
import Util exposing (..)
import DataTypes exposing (HomeDataItem)


-- MODEL --


type alias Model =
    { focused : Int
    , hovered : Int
    , menuOpen : Bool
    , buttonFocused : Bool
    , selected : List Category
    , options : List Category
    }


initialModel : Model
initialModel =
    { focused = -1
    , hovered = -1
    , menuOpen = False
    , buttonFocused = False
    , selected = []
    , options = []
    }


type alias Config =
    { inputAlignment : String }


type alias Category =
    HomeDataItem


emptyCategory : Category
emptyCategory =
    { name = "", id = "", enabled = False, description = "" }


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


view : Model -> Config -> Html Msg
view model { inputAlignment } =
    let
        { selected, menuOpen, focused, options } =
            model

        menuClass =
            classNames
                [ ( "list bg-white absolute z-4 ma0 ph0 pv2 list tl bg-white shadow-1 top-150 b--solid b--light-gray ba w30rem", menuOpen )
                , ( "right-0", inputAlignment /= "left" )
                , ( "left-0", inputAlignment == "left" )
                , ( "dn", not menuOpen )
                ]

        numberSelected =
            List.length selected

        atLeastOneSelected =
            numberSelected > 0

        atLeastOneOption =
            List.length options > 0

        buttonClass =
            classNames
                [ ( "w-100 h2 pv2 ph3 tl br-pill ba b--solid b--blue bg-white truncate-ns", True )
                , ( "bg-blue white b", menuOpen )
                ]

        buttonText =
            if numberSelected == 0 then
                "Choose categories"
            else if numberSelected == 1 then
                Maybe.withDefault emptyCategory (List.head selected)
                    |> .name
            else
                toString (List.length selected) ++ " categories selected"

        inputUnderlineClass =
            classNames
                [ ( "absolute top-125 w-100 ba b--blue", True )
                , ( "dn", not menuOpen )
                ]
    in
        div
            [ class "fl w-30 relative"
            , onKeyDown model
            ]
            [ button
                [ class buttonClass
                , onClick HandleButtonClick
                , onFocus HandleButtonFocus
                , onBlur HandleButtonBlur
                , type_ "button"
                , ariaControls "category-list"
                ]
                [ text buttonText ]
            , div [ class inputUnderlineClass ] []
            , viewIf (not atLeastOneOption)
                (div
                    [ class menuClass
                    , ariaExpanded (boolStr menuOpen)
                    , ariaHidden (not menuOpen)
                    , onFocus HandleMenuFocus
                    , onBlur HandleMenuBlur
                    , tabindex -1
                    ]
                    [ div [ class "ph4 pv2 f6" ] [ text "Please select an Activity" ] ]
                )
            , viewIf (atLeastOneOption)
                (div
                    [ id "category-list"
                    , class menuClass
                    , ariaExpanded (boolStr menuOpen)
                    , ariaHidden (not menuOpen)
                    , onFocus HandleMenuFocus
                    , onBlur HandleMenuBlur
                    , tabindex -1
                    ]
                    (List.indexedMap
                        (\index category ->
                            let
                                isDisabled =
                                    not category.enabled

                                isFocused =
                                    focused == index

                                isSelected =
                                    List.member category selected

                                checkboxClass =
                                    "absolute checkbox o-0"

                                checkmarkClass =
                                    classNames
                                        [ ( "checkbox__checkmark absolute w1 h1 bg-white ba bw1 b--blue br1 left-1", True )
                                        , ( "bg-blue", isSelected )
                                        ]

                                labelClass =
                                    classNames
                                        [ ( "relative db fl w-50 pt1 pb2 pl4 pr2 pointer outline-0 f6", True )
                                        , ( "o-30", isDisabled )
                                        ]

                                optionBgClass =
                                    classNames
                                        [ ( "absolute absolute--fill", True )
                                        , ( "bg-blue o-20", isFocused )
                                        ]
                            in
                                label
                                    [ class labelClass
                                    , for ("category-" ++ (toString index))
                                    , onFocus HandleLabelFocus
                                    , onBlur HandleLabelBlur
                                    , tabindex -1
                                    ]
                                    [ input
                                        [ type_ "checkbox"
                                        , onClick (HandleCheckboxClick category)
                                        , checked isSelected
                                        , disabled isDisabled
                                        , onFocus (HandleCheckboxFocus index)
                                        , onBlur HandleCheckboxBlur
                                        , name "category"
                                        , id ("category-" ++ (toString index))
                                        , class checkboxClass
                                        ]
                                        []
                                    , span [ class checkmarkClass ] []
                                    , div [ class "ml2" ] [ text category.name ]
                                    , div [ class optionBgClass ] []
                                    ]
                        )
                        model.options
                    )
                )
            ]



-- UPDATE --


type Msg
    = HandleCheckboxClick Category
    | HandleButtonFocus
    | HandleButtonClick
    | HandleButtonBlur
    | HandleCheckboxFocus Int
    | HandleCheckboxBlur
    | HandleLabelFocus
    | HandleLabelBlur
    | HandleMenuFocus
    | HandleMenuBlur
    | HandleEnter
    | HandleEscape
    | NoOp


handleCheckboxFocus : Int -> Model -> Model
handleCheckboxFocus index model =
    { model | focused = index }


handleComponentFocus : Model -> Model
handleComponentFocus model =
    { model | menuOpen = True }


handleComponentBlur : Model -> Model
handleComponentBlur model =
    { model | menuOpen = False, hovered = -1, focused = -1 }


handleButtonFocus : Model -> Model
handleButtonFocus model =
    { model | buttonFocused = True }


handleButtonBlur : Model -> Model
handleButtonBlur model =
    { model | buttonFocused = False }


toggleCategorySelected : Category -> Model -> Model
toggleCategorySelected category model =
    let
        alreadySelected =
            List.member category model.selected

        exclude option el =
            option /= el
    in
        if alreadySelected then
            { model | selected = List.filter (exclude category) model.selected }
        else
            { model | selected = model.selected ++ [ category ] }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleCheckboxClick clickedCategory ->
            ( toggleCategorySelected clickedCategory model, Cmd.none )

        HandleButtonClick ->
            let
                { menuOpen, buttonFocused } =
                    model

                handleButtonClick =
                    if not menuOpen && not buttonFocused then
                        handleButtonFocus >> handleComponentFocus
                    else if not menuOpen && buttonFocused then
                        handleButtonBlur >> handleComponentFocus
                    else if menuOpen && not buttonFocused then
                        handleButtonFocus >> handleComponentBlur
                    else
                        handleButtonBlur
            in
                ( handleButtonClick model, Cmd.none )

        HandleButtonFocus ->
            let
                { menuOpen } =
                    model

                buttonFocus =
                    if menuOpen then
                        handleButtonFocus >> handleComponentBlur
                    else
                        handleButtonFocus >> handleComponentFocus
            in
                ( buttonFocus model, Cmd.none )

        HandleButtonBlur ->
            ( handleButtonBlur (handleComponentBlur model), Cmd.none )

        HandleCheckboxFocus index ->
            ( handleComponentFocus (handleCheckboxFocus index model), Cmd.none )

        HandleCheckboxBlur ->
            ( handleComponentBlur model, Cmd.none )

        HandleLabelFocus ->
            ( handleComponentFocus model, Cmd.none )

        HandleLabelBlur ->
            ( handleComponentBlur model, Cmd.none )

        HandleMenuFocus ->
            ( handleComponentFocus model, Cmd.none )

        HandleMenuBlur ->
            ( handleComponentBlur model, Cmd.none )

        HandleEscape ->
            ( handleComponentBlur model, Cmd.none )

        HandleEnter ->
            let
                { focused, options } =
                    model

                shouldToggle =
                    focused > -1

                category =
                    Maybe.withDefault emptyCategory (focused !! options)
            in
                if shouldToggle then
                    ( toggleCategorySelected category model, Cmd.none )
                else
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
