module InputHelper exposing (inputs, unwrapToString)

import Element exposing (rgba, text)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput)
import Maybe
import Maybe.Extra exposing (unwrap)


unwrapToString : Maybe Int -> String
unwrapToString =
    unwrap "" String.fromInt


inputs : String -> (String -> msg) -> String -> Element.Element msg
inputs description inputType getValue =
    Input.text
        [ Font.color (rgba 0 0 0 1) ]
        { text = getValue
        , placeholder = Just (Input.placeholder [] (text description))
        , onChange = inputType
        , label = Input.labelAbove [ Font.underline, Font.color (rgba 0 0 0 1) ] (text description)
        }
