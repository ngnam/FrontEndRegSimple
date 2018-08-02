module Dialog.UserType exposing (userTypeDialog)

import Dialog.Dialog exposing (dialog)
import Model exposing (Msg(..))
import Html exposing (Html, section, h1, form, fieldset, p, div, button, input, label, text, span)
import Html.Attributes exposing (class, type_, checked, for, name, id, placeholder, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import DataTypes exposing (UserTypeForm)
import DictList exposing (member)
import Util exposing (viewIf)


userTypeDialog model =
    dialog (view model) UserTypeDialogClose "user-type-dialog" model.isOpen


view : UserTypeForm -> Html Msg
view { selected, freeText } =
    let
        selectedValue =
            Maybe.withDefault "" selected
    in
        section
            [ class "pa3" ]
            [ h1 [ class "mb2" ] [ text "About you" ]
            , form
                [ class "w-100", onSubmit UserTypeFormSubmit ]
                [ fieldset [ class "mb2" ]
                    [ p
                        [ class "tl mb2" ]
                        [ text "Which of the following best applies to you?" ]
                    , div [ class "mb2 cf" ] <|
                        List.map (radio selectedValue) userTypes
                    , viewIf
                        (selectedValue == "Other")
                        (input
                            [ type_ "text"
                            , class "fl mb1 f5 paq"
                            , placeholder "Type here..."
                            , onInput UserTypeFreeTextOnInput
                            , value freeText
                            ]
                            []
                        )
                    ]
                , button
                    [ class "bn f5 bg-blue white outline-0 pa2 br-pill button" ]
                    [ text "Submit" ]
                ]
            ]


radio selectedValue { radioValue, labelText } =
    label
        [ class "db fl w-100 pv1 tl radio-button relative", for radioValue ]
        [ input
            [ type_ "radio"
            , class "radio-button__input"
            , checked (selectedValue == radioValue)
            , onClick <| UserTypeSelect radioValue
            , name "User type"
            , id radioValue
            ]
            []
        , span [ class "radio-button__circle" ] []
        , span [ class "radio-button__focus-fill" ] []
        , span [ class "relative ml2" ] [ text labelText ]
        ]


userTypes =
    [ { radioValue = "FinTech SMEs"
      , labelText = "FinTech SMEs"
      }
    , { radioValue = "Large Financial Institution"
      , labelText = "Large Financial Institution"
      }
    , { radioValue = "Government"
      , labelText = "Government"
      }
    , { radioValue = "Regulator or Policymaker"
      , labelText = "Regulator or Policymaker"
      }
    , { radioValue = "International Organisation"
      , labelText = "International Organisation"
      }
    , { radioValue = "Professional Services Firm"
      , labelText = "Professional Services Firm"
      }
    , { radioValue = "Academic"
      , labelText = "Academic"
      }
    , { radioValue = "Other"
      , labelText = "Other"
      }
    ]
