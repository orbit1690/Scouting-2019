module Scouting exposing (Model, Msg, init, main, update, view)

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


matchOrganizer : Int -> Int -> Int -> Int -> Int -> Int -> List ( Int, String )
matchOrganizer t1 t2 t3 t4 t5 t6 =
    [ ( t1, "כחול 1" ), ( t2, "כחול 2" ), ( t3, "כחול 3" ), ( t4, "אדום 1" ), ( t5, "אדום 2" ), ( t6, "אדום 3" ) ]


driverStations : List (List ( Int, String ))
driverStations =
    [ matchOrganizer 1690 1574 3339 254 2056 1323
    , matchOrganizer 118 1577 1024 2056 1690 254
    , matchOrganizer 1574 3339 1577 1323 1024 118
    , matchOrganizer 3339 1574 1577 1024 118 2056
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
            }

        MatchInput input ->
            { model
                | match = String.toInt input
            }

        Start ->
            { model
                | isStarted = not model.isStarted
            }


unwrapToString : Maybe Int -> String
unwrapToString maybeInt =
    unwrap "" String.fromInt maybeInt


getMatchStations : Int -> List ( Int, String )
getMatchStations match =
    withDefault [ ( 0, "" ) ] <| getAt match driverStations



{- }
   teamInStation : Int -> Int
   teamInStation match =
       first <| getMatchStations match
-}


driverStationChooser : Maybe Int -> Maybe Int -> String
driverStationChooser team match =
    case elemIndex of
        a ->
            if first a == team then
                second a

            else
                ""

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
        [ Html.text <| "Pre-Scout screen:   " ++ driverStationChooser model.match model.team
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
                ]
        , startButton model
        ]
