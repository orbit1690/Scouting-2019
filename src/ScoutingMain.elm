module ScoutingMain exposing (Model, Msg, init, subscriptions, update, view)

import AutonomousDataView
import Browser
import Debug
import Html exposing (button, div, input, label, text)
import Html.Attributes as Attributes exposing (placeholder, style, type_, value)
import Html.Events as Events exposing (onClick, onInput)
import Http
import Json.Decode
import String
import TeamDataView


main : Program () Model Msg
main =
    Browser.element
        { init = always ( init, Cmd.none )
        , view = view
        , update = \msg model -> ( update msg model, Cmd.none )
        , subscriptions = subscriptions
        }


type Pages
    = Page1
    | Page2


type Msg
    = TeamDataMsg TeamDataView.Msg
    | AutonomousDataMsg AutonomousDataView.Msg
    | NextPage1To2


type alias Model =
    { teamData : TeamDataView.Model
    , autonomousData : AutonomousDataView.Model
    , pages : Pages
    }


createButton : Msg -> String -> Html.Html Msg
createButton bmsg bname =
    div [] [ button [ onClick bmsg ] [ Html.text bname ] ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        TeamDataMsg tmsg ->
            { model | teamData = TeamDataView.update tmsg model.teamData }

        AutonomousDataMsg amsg ->
            { model | autonomousData = AutonomousDataView.update amsg model.autonomousData }

        NextPage1To2 ->
            { model | pages = Page2 }


view : Model -> Html.Html Msg
view model =
    case model.pages of
        Page1 ->
            Html.pre [] [ Html.map TeamDataMsg <| TeamDataView.view model.teamData, createButton NextPage1To2 "Next Page" ]

        Page2 ->
            Html.map AutonomousDataMsg <| AutonomousDataView.view model.autonomousData


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map AutonomousDataMsg <| AutonomousDataView.subscriptions
        , Sub.map TeamDataMsg <| TeamDataView.subscriptions
        ]


init : Model
init =
    { teamData = TeamDataView.init "" "" 0 0
    , autonomousData = AutonomousDataView.init "" "" 0 0
    , pages = Page1
    }
