module AutonomiDataView exposing (Model, Msg, init, subscriptions, update, view)

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
    , teamNum : Int
    , matchNum : Int
    , driverStationPosition : String
    }


autonomiDataView : Model -> Html.Html Msg
autonomiDataView model =
    Html.pre []
        [ checkbox model.scouterName ScouterInput "test"
        , checkbox (String.fromInt model.teamNum) TeamInput "test"
        , checkbox (String.fromInt model.matchNum) MatchInput "test"
        , checkbox model.driverStationPosition DriverStationPositionInput "test"
        ]


checkbox : String -> (String -> Msg) -> String -> Html.Html Msg
checkbox modelValue nextButton name =
    div []
        [ input [ placeholder name, onInput nextButton, value modelValue ] [] ]


checkList : String -> (String -> Msg) -> String -> Html.Html Msg
checkList modelValue nextButton name =
    label
        [ style "padding" "20px" ]
        [ input [ type_ "checkbox", placeholder name, onInput nextButton, value modelValue ] []
        , text name
        ]


init : String -> String -> Int -> Int -> Model
init sN dSP tN mN =
    { scouterName = sN
    , driverStationPosition = dSP
    , matchNum = mN
    , teamNum = tN
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ScouterInput s ->
            { model | scouterName = s }

        TeamInput s ->
            { model | teamNum = Maybe.withDefault 0 <| String.toInt s }

        MatchInput s ->
            { model | matchNum = Maybe.withDefault 0 <| String.toInt s }

        DriverStationPositionInput s ->
            { model | driverStationPosition = s }


view : Model -> Html.Html Msg
view model =
    autonomiDataView model


subscriptions : Sub Msg
subscriptions =
    Sub.none
