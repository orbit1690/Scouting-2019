module Scouting exposing (Msg, Model, init, update, main, view )

import Browser
import Html.Attributes exposing (placeholder, value)
import Html exposing (input , text)
import Html.Events exposing (onClick , onInput)


inputwriter : String -> (String -> Msg) -> String -> Html.Html Msg
inputwriter placeholderInput msg model =
    Html.div [] [
    input [placeholder placeholderInput, onInput msg, value model] []
    ,text "\n"  
    ]

type Msg =
    ScoutersNameInput String
    | TeamNumberInput String
    | MatchNumberInput String
    | DriverStationInput String
    | Page Bool


type alias Model =
    {scoutersName : String
    , scoutedTeamNumber : String
    , matchNumber : String
    , scoutedTeamDriverStationPosition : String
    , isPage : Bool
    }

main : Program () Model Msg
main = 
    Browser.element{init = always (init, Cmd.none), update = update, view = view, subscriptions = always Sub.none }

init : Model
init = {scoutersName = "", scoutedTeamNumber = "", matchNumber = "", scoutedTeamDriverStationPosition = "", isPage = False}

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        ScoutersNameInput string ->
            ({model | scoutersName = string }, Cmd.none)
        TeamNumberInput string ->
            ({model | scoutedTeamNumber = string }, Cmd.none)
        MatchNumberInput string ->
            ({model | matchNumber = string }, Cmd.none)
        DriverStationInput string ->
            ({model | scoutedTeamDriverStationPosition = string }, Cmd.none)
        Page state ->
            ({model | isPage = state}, Cmd.none)

view : Model ->  Html.Html Msg
view model = 
    if model.isPage == True then
        Html.text model.scoutersName
    else 

    Html.pre [][ 
        inputwriter "your name" ScoutersNameInput model.scoutersName
        ,inputwriter "scouted team number" TeamNumberInput model.scoutedTeamNumber
        ,inputwriter "match number" MatchNumberInput model.matchNumber
        ,inputwriter  "driver station position" DriverStationInput model.scoutedTeamDriverStationPosition
        , Html.button [onClick <| Page True] [Html.text "second page"] 
        ]
