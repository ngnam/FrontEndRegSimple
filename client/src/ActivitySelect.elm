module ActivitySelect exposing (Model, Msg, initialModel, update, view)

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


type alias Activity =
    { name : String, id : Int }


type alias Model =
    { menuOpen : Bool
    , hovered : Index
    , focused : Index
    , selected : Index
    , options : List Activity
    }


initialModel : Model
initialModel =
    { menuOpen = False
    , hovered = -1
    , focused = -1
    , selected = -1
    , options = activities
    }


emptyActivity : Activity
emptyActivity =
    { name = "Choose your activity", id = -1 }


activities : List Activity
activities =
    [ { name = "Anti-Money Laundering", id = 1 }
    , { name = "Counter-Terrorism Financing", id = 2 }
    , { name = "Transfer Pricing", id = 3 }
    , { name = "Mobile Money", id = 4 }
    , { name = "Electronic Money", id = 5 }
    , { name = "Payments", id = 6 }
    , { name = "Remitances", id = 7 }
    , { name = "Foreign Exchange", id = 8 }
    , { name = "Microfinance", id = 9 }
    , { name = "Consumer Credit", id = 10 }
    , { name = "Business Lending", id = 11 }
    , { name = "Supply Chain Finance", id = 12 }
    , { name = "Islamic Finance", id = 13 }
    , { name = "Credit Reference Services", id = 14 }
    , { name = "Equity Crowdfunding", id = 15 }
    , { name = "Public Offers", id = 16 }
    , { name = "Dealing in Investments", id = 17 }
    , { name = "Data Protection", id = 18 }
    , { name = "Robo Advice", id = 19 }
    , { name = "Crypto-Assets", id = 20 }
    , { name = "Retail Banking", id = 21 }
    , { name = "Managing Investments", id = 22 }
    , { name = "Insurance Mediation", id = 23 }
    ]


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
            ]
            (List.indexedMap
                (\index activity ->
                    label
                        [ class "relative pl4 ma1 w-40 tl f6 pointer"
                        , for ("activity-" ++ (toString index))
                        , tabindex 0
                        , onFocus (HandleOptionFocused index)
                        , onBlur HandleOptionBlur
                        , onMouseOver (HandleOptionHovered index)
                        , onMouseOut (HandleOptionHovered -1)
                        , onKeyDown
                            model
                        ]
                        [ div
                            [ class
                                "absolute left-0 w1 h1 br-100 bg-white b--blue ba fl flex flex-column justify-center items-center mr1"
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
                            , tabindex -1
                            , id ("activity-" ++ (toString index))
                            , class "clip"
                            ]
                            []
                        , text
                            activity.name
                        ]
                )
                options
            )


view : Model -> String -> Html Msg
view model inputClass =
    let
        selectedActivity =
            Maybe.withDefault emptyActivity (model.selected !! model.options)

        menuOpen =
            model.menuOpen

        menuClass =
            classNames
                [ ( "list bg-white ttc w30rem translate-center top-150 ba b--gray shadow-1 pv1 ph2", True )
                , ( "absolute flex flex-wrap justify-between ma1", menuOpen )
                , ( "dn", not menuOpen )
                ]

        buttonClass =
            inputClass ++ " tl truncate bg-white " ++ classNames [ ( "bg-blue white", menuOpen ), ( "black-60", selectedActivity.name == emptyActivity.name ) ]

        buttonUnderlineClass =
            "absolute top-125 w-100 ba b--blue"
    in
        div
            [ class "relative w-30 fl", onKeyDown model ]
            [ button
                [ onClick HandleButtonClick
                , onBlur HandleButtonBlur
                , type_ "button"
                , type_ "button"
                , placeholder "Choose your activity"
                , class buttonClass
                , ariaControls "activity-list"
                ]
                [ text selectedActivity.name ]
            , viewIf menuOpen (div [ class buttonUnderlineClass ] [])
            , activityMenu
                model
                menuClass
            ]



-- UPDATE --


type Msg
    = SetSelected Index
    | HandleButtonClick
    | HandleButtonBlur
    | HandleEscape
    | HandleOptionBlur
    | HandleOptionFocused Index
    | HandleOptionHovered Index
    | HandleEnter
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSelected selected ->
            ( { model
                | selected = selected
                , menuOpen = False
              }
            , Cmd.none
            )

        HandleOptionBlur ->
            ( { model | focused = -1, menuOpen = False }, Cmd.none )

        HandleOptionFocused index ->
            ( { model | focused = index, menuOpen = True }, Cmd.none )

        HandleOptionHovered index ->
            ( { model | hovered = index }, Cmd.none )

        HandleEscape ->
            ( { model | menuOpen = False }, Cmd.none )

        HandleEnter ->
            ( { model | selected = model.focused }, Cmd.none )

        HandleButtonBlur ->
            ( { model | menuOpen = False }, Cmd.none )

        HandleButtonClick ->
            ( { model | menuOpen = not model.menuOpen }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
