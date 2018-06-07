module CategorySelect exposing (Model, Msg, initialModel, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import ClassNames exposing (classNames)


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
    , options = categories
    }


type alias Category =
    { name : String, id : String, enabled : Bool }


emptyCategory : Category
emptyCategory =
    { name = "", id = "", enabled = False }


categories : List Category
categories =
    [ { id = "aml-authority", name = "Authority’s Enforcement, Remedial Measures & Penalties", enabled = True }
    , { id = "aml-cdd", name = "CDD, ID & Verification", enabled = True }
    , { id = "aml-disclosure", name = "Disclosure, Reporting (including STR)", enabled = True }
    , { id = "aml-edd", name = "EDD High Risk Customers", enabled = True }
    , { id = "aml-intermediary", name = "Intermediary-led Enforcement Measures", enabled = True }
    , { id = "aml-laundering", name = "Money Laundering & Associated Offences", enabled = True }
    , { id = "aml-powers", name = "Authorities: Scope, Powers & Obligations", enabled = True }
    , { id = "aml-recording", name = "Record Keeping", enabled = False }
    , { id = "aml-regulated", name = "Regulated Entities & Activities", enabled = False }
    , { id = "aml-terrorism", name = "Terrorism Financing", enabled = True }
    , { id = "aml-training", name = "Training, Responsible Persons / Departments", enabled = True }
    ]


view : Model -> Html Msg
view model =
    let
        { selected, menuOpen } =
            model

        menuClass =
            classNames
                [ ( "absolute list bg-white absolute ma0 ph0 pv2 list tl bg-white shadow-1 top-150 right-0 b--solid b--light-gray ba w30rem outline-0", menuOpen )
                , ( "dn", not menuOpen )
                ]

        numberSelected =
            List.length selected

        atLeastOneSelected =
            List.length selected > 0

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
            [ class "fl w-30 relative" ]
            [ button
                [ class "w-100 h2 pv2 ph3 tl br-pill ba b--solid b--blue outline-0 bg-white truncate-ns"
                , onClick HandleButtonClick
                , onFocus HandleButtonFocus
                , onBlur HandleButtonBlur
                , type_ "button"
                , ariaControls "category-list"
                ]
                [ text buttonText ]
            , div [ class inputUnderlineClass ] []
            , div
                [ id "category-list"
                , class menuClass
                , ariaExpanded (String.toLower (toString menuOpen))
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
                                    [ ( "relative db fl w-50 pv1 pl4 pr2 outline-0", True )
                                    , ( "o-30", isDisabled )
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
                                    , onFocus HandleCheckboxFocus
                                    , onBlur HandleCheckboxBlur
                                    , name "category"
                                    , id ("category-" ++ (toString index))
                                    , class checkboxClass
                                    ]
                                    []
                                , span [ class checkmarkClass ] []
                                , div [ class "checkbox__focus absolute w1 h1 bg-blue o-20 ba bw1 b--blue br1 left-1 dn" ] []
                                , div [ class "ml2" ] [ text category.name ]
                                ]
                    )
                    model.options
                )
            ]



-- UPDATE --


type Msg
    = HandleCheckboxClick Category
    | HandleButtonFocus
    | HandleButtonClick
    | HandleButtonBlur
    | HandleCheckboxFocus
    | HandleCheckboxBlur
    | HandleLabelFocus
    | HandleLabelBlur
    | HandleMenuFocus
    | HandleMenuBlur
    | NoOp


handleComponentFocus : Model -> Model
handleComponentFocus model =
    { model | menuOpen = True }


handleComponentBlur : Model -> Model
handleComponentBlur model =
    { model | menuOpen = False }


handleButtonFocus : Model -> Model
handleButtonFocus model =
    { model | buttonFocused = True }


handleButtonBlur : Model -> Model
handleButtonBlur model =
    { model | buttonFocused = False }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleCheckboxClick clickedCategory ->
            let
                alreadySelected =
                    List.member clickedCategory model.selected

                exclude category el =
                    category /= el
            in
                if alreadySelected then
                    ( { model | selected = List.filter (exclude clickedCategory) model.selected }, Cmd.none )
                else
                    ( { model | selected = model.selected ++ [ clickedCategory ] }, Cmd.none )

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

        HandleCheckboxFocus ->
            ( handleComponentFocus model, Cmd.none )

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

        NoOp ->
            ( model, Cmd.none )
