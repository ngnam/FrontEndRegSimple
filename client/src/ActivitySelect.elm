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


type alias Id =
    Int


type alias Activity =
    { name : String, id : Int, enabled : Bool }


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
    { name = "Choose your activity", id = -1, enabled = True }


activities : List Activity
activities =
    [ { name = "Anti-Money Laundering", id = 1, enabled = True }
    , { name = "Counter-Terrorism Financing", id = 2, enabled = False }
    , { name = "Transfer Pricing", id = 3, enabled = False }
    , { name = "Mobile Money", id = 4, enabled = False }
    , { name = "Electronic Money", id = 5, enabled = False }
    , { name = "Payments", id = 6, enabled = False }
    , { name = "Remitances", id = 7, enabled = False }
    , { name = "Foreign Exchange", id = 8, enabled = False }
    , { name = "Microfinance", id = 9, enabled = False }
    , { name = "Consumer Credit", id = 10, enabled = False }
    , { name = "Business Lending", id = 11, enabled = False }
    , { name = "Supply Chain Finance", id = 12, enabled = False }
    , { name = "Islamic Finance", id = 13, enabled = False }
    , { name = "Credit Reference Services", id = 14, enabled = False }
    , { name = "Equity Crowdfunding", id = 15, enabled = False }
    , { name = "Public Offers", id = 16, enabled = False }
    , { name = "Dealing in Investments", id = 17, enabled = False }
    , { name = "Data Protection", id = 18, enabled = False }
    , { name = "Robo Advice", id = 19, enabled = False }
    , { name = "Crypto-Assets", id = 20, enabled = False }
    , { name = "Retail Banking", id = 21, enabled = False }
    , { name = "Managing Investments", id = 22, enabled = False }
    , { name = "Insurance Mediation", id = 23, enabled = False }
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
                    let
                        isDisabled =
                            not activity.enabled

                        labelClass =
                            classNames
                                [ ( "relative pl4 ma1 w-40 tl f6"
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
                            , onFocus (HandleOptionFocused activity.id)
                            , onBlur HandleOptionBlur
                            , onMouseOver (HandleOptionHovered activity.id)
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
                                            [ ( "absolute w-75 h-75 bg-blue br-100", activity.id == selected ) ]
                                        )
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
            Maybe.withDefault emptyActivity ((model.selected - 1) !! model.options)

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
                [ onBlur HandleButtonBlur
                , onFocus HandleButtonFocus
                , onKeyDown model
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
    = SetSelected Id
    | HandleButtonBlur
    | HandleButtonFocus
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

        HandleButtonFocus ->
            ( { model | menuOpen = True }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
