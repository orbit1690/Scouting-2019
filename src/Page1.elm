module Page1 exposing (init1, update1, view1)

import Browser
import FunctionList exposing (inputs, unwrapToString)
import Html
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Scouting exposing (indexToName, startButton)


main : Program () Model Msg
main =
    Browser.sandbox
        { init1 = init1
        , view1 = view1
        , update = update
        }


type Msg
    = NameInput String
    | TeamInput String
    | MatchInput String
    | Start


type alias Model =
    { scouter : String
    , team : Maybe Int
    , match : Maybe Int
    , driverStation : String --PossibleStations
    , isStarted : Bool
    }


init1 : Model
init1 =
    { scouter = ""
    , team = Nothing
    , match = Nothing
    , driverStation = ""
    , isStarted = False
    }


view1 : Model -> Html.Html Msg
view1 model =
    Html.div []
        [ Html.text <| "Pre-Scout screen:   " ++ model.driverStation
        , Html.div []
            [ inputs "Scouter's name:" NameInput model.scouter
            , inputs "Team's number:" TeamInput << unwrapToString <| model.team
            , inputs "Match number:" MatchInput << unwrapToString <| model.match
            ]
        , startButton model
        ]


update1 : Msg -> Model -> Model
update1 msg model =
    case msg of
        NameInput input ->
            { model
                | scouter = input
            }

        TeamInput input ->
            { model
                | team = String.toInt input
                , driverStation = indexToName (String.toInt input) model.match
            }

        MatchInput input ->
            { model
                | match = String.toInt input
                , driverStation = indexToName model.team (String.toInt input)
            }

        Start ->
            { model
                | isStarted = not model.isStarted
                , driverStation = indexToName model.team model.match
            }
