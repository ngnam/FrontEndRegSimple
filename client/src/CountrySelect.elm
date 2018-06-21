module CountrySelect exposing (Model, Msg, initialModel, update, view, Country, emptyCountry)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import ClassNames exposing (classNames)
import Util exposing (..)


-- MODEL --


type alias Index =
    Int


type alias Model =
    { focused : Index
    , hovered : Index
    , menuOpen : Bool
    , selected : Index
    , query : String
    , options : List Country
    , selectedCountry : Maybe Country
    , countries : List Country
    }


initialModel : Model
initialModel =
    { focused = -1
    , hovered = -1
    , menuOpen = False
    , query = ""
    , options = []
    , selected = -1
    , selectedCountry = Nothing
    , countries = []
    }


type alias Country =
    { name : String, id : String }


emptyCountry : Country
emptyCountry =
    { name = "", id = "" }


source : List Country -> String -> List Country
source countries query =
    List.filter (\c -> String.contains (String.toLower query) (String.toLower c.name)) countries


optionsAvailable : List Country -> Bool
optionsAvailable options =
    List.length options > 0



-- VIEW --


onKeyDown : Model -> Attribute Msg
onKeyDown model =
    let
        options =
            { defaultOptions | preventDefault = True }

        focusIsOnOption =
            model.focused /= -1

        filterKey code =
            if code == 13 then
                Json.succeed HandleEnter
            else if code == 27 then
                Json.succeed HandleEscape
            else if code == 32 && focusIsOnOption then
                Json.succeed HandleSpace
            else if code == 38 then
                Json.succeed HandleUpArrow
            else if code == 40 then
                Json.succeed HandleDownArrow
            else
                Json.fail "ignored input"

        decoder =
            Html.Events.keyCode
                |> Json.andThen filterKey
    in
        onWithOptions "keydown" options decoder


view : Model -> Html Msg
view model =
    let
        { menuOpen, focused, hovered, selected, countries, selectedCountry } =
            model

        optionFocused =
            focused /= -1

        activeDescendant =
            if optionFocused then
                "country-select__" ++ toString focused
            else
                "false"

        menuClass =
            classNames
                [ ( "w15rem absolute z-4 ma0 ph0 pv2 list tl bg-white shadow-1 top-150 b--solid b--light-gray ba", True )
                , ( "dn", not menuOpen )
                ]

        flagClass code =
            "br-100 mr2 w1 h1 flag-icon flag-icon-squared flag-icon-" ++ String.toLower code

        inputUnderlineClass menuOpen =
            classNames
                [ ( "absolute top-125 w-100 ba b--blue", True )
                , ( "dn", not menuOpen )
                ]

        optionClass =
            "relative pv1 ph3 lh-copy pointer"

        optionBgClass active =
            classNames
                [ ( "absolute absolute--fill", True )
                , ( "bg-blue o-20", active )
                ]

        showInputFlag =
            selected /= -1 && not menuOpen

        selectedCountryCode =
            .id (Maybe.withDefault emptyCountry selectedCountry)

        inputClass =
            classNames
                [ ( "w-100 h2 pv2 pr3 br-pill ba b--solid b--blue", True )
                , ( "pl3", not showInputFlag )
                , ( "pl4", showInputFlag )
                ]
    in
        div
            [ class "w-30 fl relative"
            , onKeyDown model
            , role "combobox"
            , ariaExpanded (boolStr menuOpen)
            ]
            [ input
                [ class inputClass
                , type_ "text"
                , placeholder "Type your country"
                , onInput SetQuery
                , onBlur HandleInputBlur
                , value model.query
                , role "textbox"
                , ariaActiveDescendant activeDescendant
                ]
                []
            , viewIf showInputFlag
                (div
                    [ class "absolute top-0 bottom-0 flex flex-column justify-center pl2" ]
                    [ span [ class (flagClass selectedCountryCode) ] []
                    ]
                )
            , div [ class (inputUnderlineClass menuOpen) ] []
            , ul [ class menuClass, role "listbox" ]
                (model.options
                    |> List.take 8
                    |> List.indexedMap
                        (\index country ->
                            li
                                [ onClick (HandleOptionClick index)
                                , onMouseEnter (HandleOptionMouseEnter index)
                                , onMouseOut (HandleOptionMouseOut index)
                                , value model.query
                                , class optionClass
                                , tabindex -1
                                , role "option"
                                , ariaSelected (boolStr (focused == index))
                                ]
                                [ div [ class (optionBgClass (focused == index || hovered == index)) ] []
                                , div [ class (flagClass country.id) ] []
                                , text country.name
                                ]
                        )
                )
            ]



-- UPDATE --


type Msg
    = SetQuery String
    | HandleUpArrow
    | HandleDownArrow
    | HandleOptionClick Index
    | HandleOptionMouseEnter Index
    | HandleOptionMouseOut Index
    | HandleInputBlur
    | HandleEnter
    | HandleEscape
    | HandleSpace
    | NoOp


templateInputValue : Country -> String
templateInputValue option =
    option.name


newQuery : Index -> Model -> String
newQuery index model =
    let
        { options } =
            model

        selectedOption =
            case index !! options of
                Just a ->
                    a

                Nothing ->
                    emptyCountry

        newQuery =
            templateInputValue selectedOption
    in
        newQuery


handleOptionMouseEnter : Index -> Model -> Model
handleOptionMouseEnter index model =
    { model | hovered = index }


handleOptionMouseOut : Index -> Model -> Model
handleOptionMouseOut index model =
    { model | hovered = -1 }


handleOptionFocus : Index -> Model -> Model
handleOptionFocus index model =
    { model
        | focused = index
        , hovered = -1
        , selected = index
        , selectedCountry = index !! model.options
    }


handleInputBlur : Model -> Model
handleInputBlur model =
    let
        { focused, hovered, menuOpen, options, query, selected } =
            model

        hoveringAnOption =
            hovered /= -1

        focusingAnOption =
            focused /= -1
    in
        if focusingAnOption then
            { model | focused = -1, menuOpen = False, query = newQuery selected model }
        else if not hoveringAnOption then
            { model | focused = -1, menuOpen = False }
        else
            { model
                | focused = -1
                , menuOpen = False
                , query = newQuery hovered model
                , selected = hovered
                , selectedCountry = hovered !! options
            }


handleOptionClick : Index -> Model -> Model
handleOptionClick index model =
    { model
        | focused = -1
        , menuOpen = False
        , query = newQuery index model
        , selected = index
        , selectedCountry = index !! model.options
    }


handleEnter : Model -> Model
handleEnter model =
    let
        { menuOpen, selected } =
            model

        hasSelectedOption =
            selected > -1
    in
        if menuOpen && hasSelectedOption then
            handleOptionClick selected model
        else
            model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetQuery query ->
            let
                queryEmpty =
                    String.isEmpty query

                queryChanged =
                    String.length query /= String.length model.query

                searchForOptions =
                    queryChanged && not queryEmpty

                options =
                    source model.countries query

                menuOpen =
                    searchForOptions && optionsAvailable options
            in
                ( { model
                    | query = query
                    , menuOpen = menuOpen
                    , options = options
                    , selected = -1
                    , selectedCountry = Nothing
                  }
                , Cmd.none
                )

        HandleUpArrow ->
            let
                { selected, menuOpen } =
                    model

                isNotAtTop =
                    selected /= -1

                allowMoveUp =
                    isNotAtTop && menuOpen
            in
                if allowMoveUp then
                    ( handleOptionFocus (selected - 1) model, Cmd.none )
                else
                    ( model, Cmd.none )

        HandleDownArrow ->
            let
                { menuOpen, options, selected } =
                    model

                isNotAtBottom =
                    selected /= List.length options - 1

                allowMoveDown =
                    isNotAtBottom && menuOpen
            in
                if allowMoveDown then
                    ( handleOptionFocus (selected + 1) model, Cmd.none )
                else
                    ( model, Cmd.none )

        HandleOptionClick index ->
            let
                newModel =
                    handleOptionClick index model
            in
                ( newModel, Cmd.none )

        HandleOptionMouseEnter index ->
            let
                newModel =
                    handleOptionMouseEnter index model
            in
                ( newModel, Cmd.none )

        HandleOptionMouseOut index ->
            let
                newModel =
                    handleOptionMouseOut index model
            in
                ( newModel, Cmd.none )

        HandleInputBlur ->
            let
                newModel =
                    handleInputBlur model
            in
                ( newModel, Cmd.none )

        HandleEnter ->
            let
                newModel =
                    handleInputBlur model
            in
                ( newModel, Cmd.none )

        HandleEscape ->
            ( { model | menuOpen = False }, Cmd.none )

        HandleSpace ->
            let
                { focused } =
                    model

                focusIsOnOption =
                    focused /= -1
            in
                if focusIsOnOption then
                    ( handleOptionClick focused model, Cmd.none )
                else
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
