module Scouting exposing (Model, Msg, driverStations, init, main, update, view)

import Browser
import Html
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import List.Extra exposing (elemIndex, getAt)
import Maybe exposing (withDefault)
import Maybe.Extra exposing (unwrap)
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


driverStations : List (List Int)
driverStations =
    [ [ 1690, 1574, 3339, 254, 2056, 1323 ]
    , [ 118, 1577, 1024, 2056, 1690, 254 ]
    , [ 1574, 3339, 1577, 1323, 1024, 118 ]
    , [ 3339, 1574, 1577, 1024, 118, 2056 ]
    ]


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


unwrapToString : Maybe Int -> String
unwrapToString maybeInt =
    unwrap "" String.fromInt maybeInt


getMatchStations : Int -> List Int
getMatchStations match =
    -- == [team1, team2, team3, team4, team5, team6]
    withDefault [ 0 ] <| getAt match driverStations


stationIndex : Maybe Int -> Maybe Int -> String
stationIndex team match =
    -- team2 -> index = 2
    unwrapToString << elemIndex (withDefault 0 team) << getMatchStations <| (withDefault 0 match) - 1


indexToName : Maybe Int -> Maybe Int -> String
indexToName team match =
    -- Gets model.team and model.match from update, and calls stationIndex
    case stationIndex team match of
        "0" ->
            "כחול 1"

        "1" ->
            "כחול 2"

        "2" ->
            "כחול 3"

        "3" ->
            "אדום 1"

        "4" ->
            "אדום 2"

        "5" ->
            "אדום 3"

        _ ->
            ""


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


startButton : Model -> Html.Html Msg
startButton model =
    Html.div []
        [ Html.button [ onClick Start ]
            [ Html.text <|
                if model.isStarted then
                    "Started"

                else
                    "Startn't"
            ]
        ]


view : Model -> Html.Html Msg
view model =
    if model.isStarted then
        view2 model

    else
        view1 model


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


view2 : Model -> Html.Html Msg
view2 model =
    Html.pre []
        [ Html.text <|
            String.concat
                [ "Status:\n"
                , "\nname - "
                , model.scouter
                , "\nteam - "
                , unwrapToString <| model.team
                , "\nmatch - "
                , unwrapToString <| model.match
                , "\nstation - "
                , model.driverStation
                , "\n\n"
                , "match1 = [ 1690, 1574, 3339 || 254, 2056, 1323 ]\n"
                , "match2 = [ 118,  1577, 1024 || 2056, 1690, 254 ]\n"
                , "match3 = [ 1574, 3339, 1577 || 1323, 1024, 118 ]\n"
                , "match4 = [ 3339, 1574, 1577 || 1024, 118, 2056 ]"
                ]
        , startButton model
        ]
