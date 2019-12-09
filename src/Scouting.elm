module Scouting exposing (Model, Msg, init, main, update, view)

import Browser
import FunctionList exposing (..)
import Html
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Matches exposing (asComment, indexToName)
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
    , driverStation : String --PossibleStations
    , isStarted : Bool
    }


type alias BoolModel =
    { isStarted : Bool }


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
        [ Html.div [ style "text-decoration" "underline" ] [ Html.text <| "Pre-Scout screen:   " ++ model.driverStation ]
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
        [ Html.div [ style "text-decoration" "underline" ] [ Html.text "Status:\n" ]
        , Html.text <|
            String.concat
                [ "\nname - "
                , model.scouter
                , "\nteam - "
                , unwrapToString <| model.team
                , "\nmatch - "
                , unwrapToString <| model.match
                , "\nstation - "
                , model.driverStation
                , "\n\n"
                , Matches.asComment
                ]
        , startButton model
        ]
