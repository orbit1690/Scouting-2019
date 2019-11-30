module ScoutingMain exposing (Model, Msg, init, subscriptions, update, view)

import AutonomiDataView
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
        , subscriptions = always subscriptions
        }


type Pages
    = Page1
    | Page2


type Msg
    = TeamDataMsg TeamDataView.Msg
    | AutonomiDataMsg AutonomiDataView.Msg
    | NextPage12


type alias Model =
    { teamData : TeamDataView.Model
    , autonomiData : AutonomiDataView.Model
    , pages : Pages
    }


createButton : Msg -> String -> Html.Html Msg
createButton bmsg bname =
    div [] [ button [ onClick bmsg ] [ Html.text bname ] ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        TeamDataMsg tmsg ->
            TeamDataView.update tmsg model.teamData

        AutonomiDataMsg amsg ->
            AutonomiDataView.update amsg model.autonomiData

        NextPage12 ->
            { model | pages = Page2 }


view : Model -> Html.Html Msg
view model =
    case model.pages of
        Page1 ->
            Html.pre [] [ TeamDataView.view model.teamData, createButton NextPage12 "Next Page" ]

        Page2 ->
            AutonomiDataView.view model.autonomiData


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map AutonomiDataMsg <| AutonomiDataView.subscriptions
        , Sub.map TeamDataMsg <| TeamDataView.subscriptions
        ]


init : Model
init =
    { teamData = TeamDataView.init "" "" 0 0
    , autonomiData = AutonomiDataView.init "" "" 0 0
    , pages = Page1
    }
