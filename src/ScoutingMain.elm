module ScoutingMain exposing (Model, Msg)

import Browser
import Debug
import Html exposing (button, div, input, label, text)
import Html.Attributes as Attributes exposing (placeholder, style, type_, value)
import Html.Events as Events exposing (onClick)
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


type alias Model =
    { scouterName : String
    , teamNum : String
    , matchNum : String
    , driverStationPosition : String
    , pages : Pages
    }


init : Model
init =
    { scouterName = ""
    , teamNum = ""
    , matchNum = ""
    , driverStationPosition = ""
    , pages = P1
    }


checkbox : String -> Msg -> String -> Html.Html Msg
checkbox modelValue nextButton name =
    label
        [ style "padding" "20px" ]
        [ input [ type_ "checkbox", onClick nextButton, value modelValue ] []
        , text name
        ]


teamDataView : Model -> Html.Html Msg
teamDataView model =
    div []
        [ checkbox model.scouterName <| ScouterInput "Scouter's name"
        , checkbox model.teamNum <| TeamInput "Scouted team number"
        , checkbox model.matchNum <| MatchInput "Match number"
        , checkbox model.driverStationPosition <| DriverStationPositionInput "Scouted team driver station position"
        ]


autonomiDataView : Html.Html Msg
autonomiDataView =
    div []
        [ text "not created yet" ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        ScouterInput s ->
            { model | scouterName = s }

        TeamInput s ->
            { model | teamNum = s }

        MatchInput s ->
            { model | matchNum = s }

        DriverStationPositionInput s ->
            { model | driverStationPosition = s }


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
