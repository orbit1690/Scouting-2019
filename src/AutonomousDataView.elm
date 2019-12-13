module AutonomousDataView exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (button, div, input, label, text)
import Html.Attributes as Attributes exposing (placeholder, style, type_, value)
import Html.Events as Events exposing (onClick, onInput)
import Http
import Json.Decode
import String


type Msg
    = ScouterInput String
    | TeamInput String
    | MatchInput String
    | DriverStationPositionInput String


type alias Model =
    { scouterName : String
    , team : Int
    , match : Int
    , driverStationPosition : String
    }


autonomousDataView : Model -> Html.Html Msg
autonomousDataView model =
    Html.pre []
        [ checkbox model.scouterName ScouterInput "test"
        , checkbox (String.fromInt model.team) TeamInput "test"
        , checkbox (String.fromInt model.match) MatchInput "test"
        , checkbox model.driverStationPosition DriverStationPositionInput "test"
        ]


checkbox : String -> (String -> Msg) -> String -> Html.Html Msg
checkbox modelValue nextButton name =
    div []
        [ input [ placeholder name, onInput nextButton, value modelValue ] [] ]


init : String -> Int -> Int -> String -> Model
init sN tN mN dsp =
    Model sN mN tN dsp


update : Msg -> Model -> Model
update msg model =
    case msg of
        ScouterInput s ->
            { model | scouterName = s }

        TeamInput s ->
            { model | team = Maybe.withDefault 0 <| String.toInt s }

        MatchInput s ->
            { model | match = Maybe.withDefault 0 <| String.toInt s }

        DriverStationPositionInput s ->
            { model | driverStationPosition = s }


view : Model -> Html.Html Msg
view model =
    autonomousDataView model


subscriptions : Sub Msg
subscriptions =
    Sub.none
