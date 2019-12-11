module FunctionList exposing (inputs, unwrapToString)

import Html
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput)
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
