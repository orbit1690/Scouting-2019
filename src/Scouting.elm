module Scouting exposing (main)

import Browser
import Html
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Maybe
import String


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
    | DriverStationInput String
    | Start


type alias Model =
    { scouterName : String
    , teamNum : Int
    , matchNum : Int
    , driverStation : String
    , isStarted : Bool
    }


init : Model
init =
    { scouterName = ""
    , teamNum = 0
    , matchNum = 0
    , driverStation = ""
    , isStarted = False
    }


dropDown_driverStation : String
dropDown_driverStation =
    "visible"


update : Msg -> Model -> Model
update msg model =
    case msg of
        NameInput input ->
            { model
                | scouterName = input
            }

        TeamInput input ->
            { model
                | teamNum = Maybe.withDefault 0 <| String.toInt input
            }

        MatchInput input ->
            { model
                | matchNum = Maybe.withDefault 0 <| String.toInt input
            }

        DriverStationInput input ->
            { model
                | driverStation = input
            }

        Start ->
            { model
                | isStarted = not model.isStarted
            }


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.text "Pre-Scout screen:"
        , Html.div []
            [ Html.input
                [ placeholder "Scouter's name..."
                , onInput NameInput
                , value model.scouterName
                ]
                []
            , Html.input
                [ placeholder "Team's number..."
                , onInput TeamInput
                , value <|
                    if 0 == model.teamNum then
                        ""

                    else
                        String.fromInt model.teamNum
                ]
                []
            , Html.input
                [ placeholder "Match number..."
                , onInput MatchInput
                , value <|
                    if 0 == model.matchNum then
                        ""

                    else
                        String.fromInt model.matchNum
                ]
                []
            , Html.input
                [ style "visibility" dropDown_driverStation
                , placeholder "Driver station..."
                , onInput DriverStationInput
                , value model.driverStation
                ]
                []
            , Html.button [ onClick Start ]
                [ Html.text <|
                    if model.isStarted then
                        "Started"

                    else
                        "Startn't"
                ]
            ]
        , Html.div []
            [ Html.text <|
                "Status:  name - "
                    ++ model.scouterName
                    ++ ", team - "
                    ++ String.fromInt model.teamNum
                    ++ ", match - "
                    ++ String.fromInt model.matchNum
                    ++ ", station - "
                    ++ model.driverStation
            ]
        ]
