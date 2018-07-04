module CategorySelect
    exposing
        ( Model
        , Msg
        , Category
        , CategoryId
        , emptyCategory
        , initialModel
        , update
        , view
        , getCategoriesFromIds
        , getCategoryById
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import Util exposing (..)
import DataTypes exposing (AppDataItem, TaxonomyId, InputAlignment(..))
import Dict


-- MODEL --


type alias CategoryId =
    TaxonomyId


type alias Model =
    { focused : Int
    , hovered : Int
    , menuOpen : Bool
    , buttonFocused : Bool
    , selected : List CategoryId
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
    { inputAlignment : InputAlignment, loadingButtonInner : Maybe (Html Msg) }


type alias Category =
    AppDataItem


emptyCategory : Category
emptyCategory =
    { name = "", id = "", enabled = False, description = "" }


toDict : List Category -> Dict.Dict String Category
toDict categories =
    categories
        |> List.map (\category -> ( category.id, category ))
        |> Dict.fromList


getCategoryById : List Category -> CategoryId -> Category
getCategoryById categories id =
    Maybe.withDefault emptyCategory (Dict.get id (toDict categories))


getCategoriesFromIds : List CategoryId -> List Category -> List Category
getCategoriesFromIds ids categories =
    List.map (getCategoryById categories) ids


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
view model { inputAlignment, loadingButtonInner } =
    let
        { selected, menuOpen, focused, options } =
            model

        menuClass =
            classList
                [ ( "list bg-white absolute z-4 ma0 ph0 pv2 list tl bg-white shadow-1 top-150 b--solid b--light-gray ba w30rem", menuOpen )
                , ( "right-0", inputAlignment == Right )
                , ( "left-0", inputAlignment == Left )
                , ( "dn", not menuOpen )
                ]

        numberSelected =
            List.length selected

        atLeastOneSelected =
            numberSelected > 0

        atLeastOneOption =
            List.length options > 0

        buttonClass =
            classList
                [ ( "w-100 h2 pv2 pl3 pr4 tl br-pill ba b--solid b--blue bg-white truncate-ns b icon icon--input-arrows", True )
                , ( "bg-blue white icon--input-arrows-white", menuOpen )
                , ( "icon--input-arrows-blue", not menuOpen )
                , ( "dark-gray", not atLeastOneOption )
                ]

        buttonText =
            if numberSelected == 0 then
                "Choose categories"
            else if numberSelected == 1 then
                getCategoryById options (Maybe.withDefault "" (List.head selected))
                    |> .name
            else
                toString (List.length selected) ++ " categories selected"

        buttonInner =
            case loadingButtonInner of
                Just el ->
                    el

                _ ->
                    text buttonText

        inputUnderlineClass =
            classList
                [ ( "absolute top-125 w-100 ba b--blue", True )
                , ( "dn", not menuOpen )
                ]
    in
        div
            [ class "fl relative f6 w-100"
            , onKeyDown model
            ]
            [ button
                [ buttonClass
                , onClick HandleButtonClick
                , onFocus HandleButtonFocus
                , onBlur HandleButtonBlur
                , type_ "button"
                , ariaControls "category-list"
                ]
                [ buttonInner ]
            , div [ inputUnderlineClass ] []
            , viewIf (not atLeastOneOption)
                (div
                    [ menuClass
                    , ariaExpanded (boolStr menuOpen)
                    , ariaHidden (not menuOpen)
                    , onFocus HandleMenuFocus
                    , onBlur HandleMenuBlur
                    , tabindex -1
                    ]
                    [ div [ class "ph4 pv2 f6" ] [ text "Please select an Activity" ] ]
                )
            , viewIf (atLeastOneOption)
                (fieldset
                    [ id "category-list"
                    , menuClass
                    , ariaExpanded (boolStr menuOpen)
                    , ariaHidden (not menuOpen)
                    , onFocus HandleMenuFocus
                    , onBlur HandleMenuBlur
                    , tabindex -1
                    ]
                    ((legend
                        [ class "clip" ]
                        [ text "Please select from the following categories (at least one required)" ]
                     )
                        :: (List.indexedMap
                                (\index category ->
                                    let
                                        isDisabled =
                                            not category.enabled

                                        isFocused =
                                            focused == index

                                        isSelected =
                                            List.member category.id selected

                                        checkboxClass =
                                            "absolute checkbox o-0"

                                        checkmarkClass =
                                            classList
                                                [ ( "checkbox__checkmark absolute w1 h1 bg-white ba bw1 b--blue br1 left-1", True )
                                                , ( "bg-blue", isSelected )
                                                ]

                                        labelClass =
                                            classList
                                                [ ( "relative db fl w-50 pt1 pb2 pl4 pr2 pointer outline-0 f6", True )
                                                , ( "o-30", isDisabled )
                                                ]

                                        optionBgClass =
                                            classList
                                                [ ( "absolute absolute--fill", True )
                                                , ( "bg-blue o-20", isFocused )
                                                ]
                                    in
                                        label
                                            [ labelClass
                                            , for ("category-" ++ (toString index))
                                            , onFocus HandleLabelFocus
                                            , onBlur HandleLabelBlur
                                            , tabindex -1
                                            ]
                                            [ input
                                                [ type_ "checkbox"
                                                , onClick (HandleCheckboxClick category.id)
                                                , checked isSelected
                                                , disabled isDisabled
                                                , onFocus (HandleCheckboxFocus index)
                                                , onBlur HandleCheckboxBlur
                                                , name "category"
                                                , id ("category-" ++ (toString index))
                                                , class checkboxClass
                                                ]
                                                []
                                            , span [ checkmarkClass ] []
                                            , div [ class "ml2" ] [ text category.name ]
                                            , div [ optionBgClass ] []
                                            ]
                                )
                                model.options
                           )
                    )
                )
            ]



-- UPDATE --


type Msg
    = HandleCheckboxClick CategoryId
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


toggleCategorySelected : CategoryId -> Model -> Model
toggleCategorySelected categoryId model =
    let
        alreadySelected =
            List.member categoryId model.selected

        exclude option el =
            option /= el
    in
        if alreadySelected then
            { model | selected = List.filter (exclude categoryId) model.selected }
        else
            { model | selected = [ categoryId ] }



-- remove above line and uncomment below line to enable multiple categories
-- { model | selected = model.selected ++ [ categoryId ] }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleCheckboxClick clickedCategoryId ->
            ( toggleCategorySelected clickedCategoryId model, Cmd.none )

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
                    ( toggleCategorySelected category.id model, Cmd.none )
                else
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
