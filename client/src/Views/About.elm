module Views.About exposing (..)

import Model exposing (Model, Msg)
import Html exposing (Html, text, div, form, input, button, span, main_, section, img, header, figure, figcaption)
import Html.Attributes exposing (src, class, alt)
import Html.Attributes.Aria exposing (role)


view : Model -> Html Msg
view model =
    main_ [ role "main", class "flex-1 flex flex-column justify-evenly" ]
        [ header []
            [ img
                [ class "w12rem mb2", src "/assets/logos/logo-with-text.png", alt "RegSimple logo" ]
                []
            ]
        , section [ class "cf mw7 center" ] <|
            List.map
                aboutFigure
                figureList
        ]


figureList =
    [ { imgSrc = "/assets/icons/auto-aggregate.svg"
      , imgAlt = "Graphic: Sphere or globe with lines extending from it"
      , captionText = "Auto-aggregates regulatory information globally "
      }
    , { imgSrc = "/assets/icons/synthesise.svg"
      , imgAlt = "Graphic: Paper going a funnel with dna like atomic stucture underneath"
      , captionText = "Synthesises and summarises the essentials"
      }
    , { imgSrc = "/assets/icons/simple-interface.svg"
      , imgAlt = "Graphic: Small sphere/globe, and behind it paper with a graph on it"
      , captionText = " Simple interface compares regulations globally"
      }
    , { imgSrc = "/assets/icons/notification-change.svg"
      , imgAlt = "Graphic: Clock in center, with a circle, a square, and a triangle rotating round it"
      , captionText = "Personalised notifications tracking regulatory change"
      }
    , { imgSrc = "/assets/icons/tools.svg"
      , imgAlt = "Graphic: A spanner crossed over a screwdriver"
      , captionText = "Interactive tools to manage and share insights"
      }
    , { imgSrc = "/assets/icons/system.svg"
      , imgAlt = "Graphic: A cloud or brain at the top, with lines connected it to three devices at the bottom"
      , captionText = "System learns from experts and user feedback "
      }
    ]


aboutFigure { imgSrc, imgAlt, captionText } =
    figure [ class "w-third fl f6 mv2 dark-gray" ]
        [ img
            [ src imgSrc
            , alt imgAlt
            , class "w3"
            ]
            []
        , figcaption
            [ class "w12rem mv2 b ph4 center" ]
            [ text captionText ]
        ]
