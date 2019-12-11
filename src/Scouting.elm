module Scouting exposing (Model, Msg, init, main, update, view)

import Browser
import FunctionList exposing (inputs, unwrapToString)
import Html
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Matches exposing (asComment, stationIndex)
import Tuple exposing (first, second)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
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
    , driverStation : String
    , isStarted : Bool
    }


init : Model
init =
    { scouter = ""
    , team = Nothing
    , match = Nothing
    , driverStation = ""
    , isStarted = False
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        NameInput input ->
            { model
                | scouter = input
            }

        TeamInput input ->
            { model
                | team = String.toInt input
                , driverStation = stationIndex (String.toInt input) model.match
            }

        MatchInput input ->
            { model
                | match = String.toInt input
                , driverStation = stationIndex model.team (String.toInt input)
            }

        Start ->
            { model
                | isStarted = not model.isStarted
                , driverStation = stationIndex model.team model.match
            }


startButton : Bool -> Html.Html Msg
startButton isStarted =
    Html.div []
        [ Html.button [ onClick Start ]
            [ Html.text <|
                if isStarted then
                    "Started"

                else
                    "Startn't"
            ]
        ]


type alias StrModel =
    { scouter : String
    , team : String
    , match : String
    , driverStation : String
    , isStarted : Bool
    }


view : Model -> Html.Html Msg
view model =
    let
        strModel : StrModel
        strModel =
            { scouter = model.scouter
            , team = unwrapToString model.team
            , match = unwrapToString model.match
            , driverStation = model.driverStation
            , isStarted = model.isStarted
            }
    in
    if model.isStarted then
        view2 strModel

    else
        view1 strModel


view1 : StrModel -> Html.Html Msg
view1 model =
    Html.div []
        [ Html.div
            [ style "text-decoration" "underline" ]
            [ Html.text <| "Pre-Scout screen:   " ++ model.driverStation ]
        , Html.div []
            [ inputs "Scouter's name:" NameInput model.scouter
            , inputs "Team's number:" TeamInput model.team
            , inputs "Match number:" MatchInput model.match
            ]
        , startButton model.isStarted
        ]


view2 : StrModel -> Html.Html Msg
view2 model =
    Html.pre []
        [ Html.div
            [ style "text-decoration" "underline" ]
            [ Html.text "Status:\n" ]
        , Html.text <|
            String.concat
                [ "\nname - "
                , model.scouter
                , "\nteam - "
                , model.team
                , "\nmatch - "
                , model.match
                , "\nstation - "
                , model.driverStation
                , "\n\n"
                , Matches.asComment
                ]
        , startButton model.isStarted
        ]
