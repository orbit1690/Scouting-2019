module ScoutingMain exposing (Model, Msg)

import Browser
import Debug
import Html exposing (button, div, input, label, text)
import Html.Attributes as Attributes exposing (placeholder, style, type_, value)
import Html.Events as Events exposing (onClick, onInput)
import Http
import Json.Decode
import String


main : Program () Model Msg
main =
    Browser.element
        { init = always ( init, Cmd.none )
        , view = view
        , update = \msg model -> ( update msg model, Cmd.none )
        , subscriptions = always subscriptions
        }


type Pages
    = P1
    | P2


type Msg
    = ScouterInput String
    | TeamInput String
    | MatchInput String
    | DriverStationPositionInput String
    | Move


type alias Model =
    { scouterName : Int
    , teamNum : Int
    , matchNum : String
    , driverStationPosition : String
    , pages : Pages
    }


init : Model
init =
    { scouterName = 0
    , teamNum = 0
    , matchNum = ""
    , driverStationPosition = ""
    , pages = P1
    }


checkbox : String -> (String -> Msg) -> String -> Html.Html Msg
checkbox modelValue nextButton name =
    div []
        [ input [ placeholder name, onInput nextButton, value modelValue ] [] ]


teamDataView : Model -> Html.Html Msg
teamDataView model =
    Html.pre []
        [ checkbox (String.fromInt model.scouterName) ScouterInput "Scouter's name"
        , checkbox (String.fromInt model.teamNum) TeamInput "Scouted team number"
        , checkbox model.matchNum MatchInput "Match number"
        , checkbox model.driverStationPosition DriverStationPositionInput "Scouted team driver station position"
        , button [ onClick Move ] [ Html.text "Move" ]
        ]


autonomiDataView : Html.Html Msg
autonomiDataView =
    div []
        [ text "not created yet" ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        ScouterInput s ->
            { model | scouterName = Maybe.withDefault 0 <| String.toInt s }

        TeamInput s ->
            { model | teamNum = Maybe.withDefault 0 <| String.toInt s }

        MatchInput s ->
            { model | matchNum = s }

        DriverStationPositionInput s ->
            { model | driverStationPosition = s }

        Move ->
            { model | pages = P2 }


view : Model -> Html.Html Msg
view model =
    case model.pages of
        P1 ->
            teamDataView model

        P2 ->
            autonomiDataView


subscriptions : Sub Msg
subscriptions =
    Sub.none
