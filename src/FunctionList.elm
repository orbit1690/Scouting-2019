module FunctionList exposing (..)

import Html
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Maybe
import Maybe.Extra exposing (unwrap)


unwrapToString : Maybe Int -> String
unwrapToString maybeInt =
    unwrap "" String.fromInt maybeInt


inputs : String -> (String -> msg) -> String -> Html.Html msg
inputs description inputType getValue =
    Html.pre []
        [ Html.text <| description
        , Html.div []
            [ Html.input
                [ placeholder <| String.replace ":" "..." description
                , onInput inputType
                , value getValue
                ]
                []
            ]
        ]
