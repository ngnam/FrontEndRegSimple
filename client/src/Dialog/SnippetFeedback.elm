module Dialog.SnippetFeedback exposing (snippetFeedbackDialog)

import Html exposing (Html, Attribute, div, p, h1, section, form, input, text, legend, label, fieldset, button, span)
import Html.Attributes exposing (id, class, classList, tabindex, for, type_, name, disabled, required, checked)
import Html.Attributes.Aria exposing (ariaControls, ariaExpanded, ariaHidden)
import Html.Events exposing (onClick)
import Helpers.AppData exposing (getActivities, getActivityName, getCategoryById, getCategories)
import Model
    exposing
        ( Model
        , Msg
            ( ActivityFeedbackClick
            , ActivityMenuFeedbackToggleClick
            , CategoryMenuFeedbackToggleClick
            , SnippetFeedbackDialogCloseClick
            , CategoryFeedbackClick
            , SnippetSuggestClick
            )
        )
import DataTypes exposing (ActivityMenuFeedbackModel, CategoryMenuFeedbackModel, SnippetDialogModel)
import Util exposing (viewIf, boolStr)
import Dialog.Dialog exposing (dialog)


snippetFeedbackDialog model isOpen =
    dialog (view model) SnippetFeedbackDialogCloseClick isOpen


view : SnippetDialogModel -> Html Msg
view model =
    let
        { activityId, activityMenuOpen, categoryIds, categoryMenuOpen, snippetData } =
            model.snippetFeedback

        data =
            model.appData

        activityOptions =
            data
                |> .taxonomy
                |> getActivities

        categoryOptions =
            data
                |> .taxonomy
                |> \taxonomy -> getCategories taxonomy activityId

        activityMenuFeedbackModel =
            { selected = activityId
            , options = activityOptions
            , activityMenuOpen = activityMenuOpen
            }

        categoryMenuFeedbackModel =
            { selected = categoryIds
            , options = categoryOptions
            , categoryMenuOpen = categoryMenuOpen
            }

        isDisabled =
            List.isEmpty categoryIds || String.isEmpty activityId

        baseButtonClass =
            "w-50 h3rem ph2 br-pill ba white b--solid b--blue bg-blue mv3 f6 metro relative"

        submitButtonClass =
            classList
                [ ( baseButtonClass
                  , True
                  )
                , ( "disabled o-30", isDisabled )
                ]
    in
        section
            [ class "flex justify-center items-center flex-column mt3 dialog--snippet-feedback" ]
            [ h1 [ class "f5 w-90 pt1 pb2 mh1 bb b--black-20 mb1" ] [ text "Re-Train RegSimple" ]
            , p [ class "f6 ma3" ] [ text "Choose up to 2 categories that the snippet should be associated with" ]
            , form [ class "w-100" ]
                [ activityMenu activityMenuFeedbackModel "list bg-white ttc w-50 fl ba b--light-gray pv2 ph0 dropdown-menu"
                , categoryMenu categoryMenuFeedbackModel "list bg-white ttc w-50 fl ba b--light-gray pv2 ph0 dropdown-menu"
                ]
            , button
                [ disabled isDisabled
                , submitButtonClass
                , onClick <| SnippetSuggestClick snippetData
                ]
                [ text "Submit" ]
            ]


buttonUnderlineClass : String
buttonUnderlineClass =
    "absolute top-125 w-100 ba b--blue"



-- Activity Input --


activityMenu : ActivityMenuFeedbackModel -> String -> Html Msg
activityMenu { options, selected } menuClass =
    fieldset
        [ id "activity-list-feedback"
        , class menuClass
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
                                    [ ( "relative db fl pl4 pt1 pb2 w-100 tl f6"
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
                                , for ("activity-feedback" ++ (toString index))
                                , tabindex tabable
                                ]
                                [ div
                                    [ class
                                        "absolute left-1 w1 h1 br-100 bg-white b--blue ba fl flex flex-column justify-center items-center mr1"
                                    ]
                                    [ div
                                        [ classList
                                            [ ( "absolute w-75 h-75 bg-blue br-100"
                                              , activity.id == selected
                                              )
                                            ]
                                        ]
                                        []
                                    ]
                                , input
                                    [ type_ "radio"
                                    , onClick (ActivityFeedbackClick activity.id)
                                    , name "activity-feedback"
                                    , disabled isDisabled
                                    , tabindex -1
                                    , id ("activity-feedback" ++ (toString index))
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


categoryMenu model menuClass =
    let
        { selected, categoryMenuOpen, options } =
            model

        numberSelected =
            List.length selected
    in
        fieldset
            [ id "category-list"
            , class menuClass
            , ariaExpanded (boolStr categoryMenuOpen)
            , ariaHidden (not categoryMenuOpen)
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
                                    (numberSelected == 2 && not isSelected)

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
                                        [ ( "relative db fl w-100 pt1 pb2 pl4 pr2 pointer outline-0 f6", True )
                                        , ( "o-30", isDisabled )
                                        ]
                            in
                                label
                                    [ labelClass
                                    , for ("category-feedback" ++ (toString index))
                                    , tabindex -1
                                    ]
                                    [ input
                                        [ type_ "checkbox"
                                        , onClick (CategoryFeedbackClick category.id)
                                        , checked isSelected
                                        , disabled isDisabled
                                        , name "category"
                                        , id ("category-feedback" ++ (toString index))
                                        , class checkboxClass
                                        ]
                                        []
                                    , span [ checkmarkClass ] []
                                    , div [ class "ml2" ] [ text category.name ]
                                    ]
                        )
                        options
                   )
            )
