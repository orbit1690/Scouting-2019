module Scouting exposing (Model, Msg, init, main, update, view)

import Auto
import Browser
import FunctionList exposing (inputs, unwrapToString)
import Html
import Html.Attributes exposing (style)
import Html.Events exposing (onClick, onInput)
import Matches exposing (asComment, stationName)


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
    , isStarted : ButtonState
    }


type ButtonState
    = Pushed
    | TriedPush
    | Untouched


init : Model
init =
    { scouter = ""
    , team = Nothing
    , match = Nothing
    , driverStation = "    " -- for inputHelpMessage
    , isStarted = Untouched
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
                , driverStation = stationName (String.toInt input) model.match
            }

        MatchInput input ->
            { model
                | match = String.toInt input
                , driverStation = stationName model.team (String.toInt input)
            }

        Start ->
            { model
                | isStarted = switchButtonState model
                , driverStation = stationName model.team model.match
            }


ifCorrectInput : Model -> ButtonState
ifCorrectInput model =
    let
        modelStr =
            strModel model

        isStation string =
            model.driverStation == string
    in
    if modelStr.scouter == "" then
        TriedPush

    else if modelStr.team == "" then
        TriedPush

    else if modelStr.match == "" then
        TriedPush

    else if isStation " " || isStation "  " then
        -- " " Not a match , "  " Team not in this match
        TriedPush

    else
        Pushed


switchButtonState : Model -> ButtonState
switchButtonState model =
    if model.isStarted == Pushed then
        Untouched

    else
        ifCorrectInput model


inputHelpMessage : String -> String
inputHelpMessage strStation =
    case strStation of
        "    " ->
            "Please fill all inputs^^"

        "  " ->
            "Team not in this match"

        " " ->
            "Not a match"

        "" ->
            "All inputs are required."

        _ ->
            ""


startButton : StrModel -> Html.Html Msg
startButton model =
    let
        ifStarted : String -> String -> Html.Html Msg
        ifStarted ifYes ifNo =
            Html.text <|
                if model.isStarted == Pushed then
                    ifYes

                else
                    ifNo
    in
    Html.pre []
        [ Html.button [ onClick Start ]
            [ ifStarted "Started" "Startn't"
            ]
        , Html.div [ style "color" "blue" ]
            [ ifStarted "" <|
                inputHelpMessage model.driverStation
            ]
        ]


type alias StrModel =
    { scouter : String
    , team : String
    , match : String
    , driverStation : String
    , isStarted : ButtonState
    }


strModel : Model -> StrModel
strModel model =
    { scouter = model.scouter
    , team = unwrapToString model.team
    , match = unwrapToString model.match
    , driverStation = model.driverStation
    , isStarted = model.isStarted
    }


view : Model -> Html.Html Msg
view model =
    if model.isStarted == Pushed then
        confirmationView <| strModel model
        {- Html.div []
           [ Auto.view model
           , startButton model
           ]
        -}
        -- planning to replace confirmaion page w Auto

    else
        registryView <| strModel model


registryView : StrModel -> Html.Html Msg
registryView model =
    Html.div []
        [ Html.div
            [ style "text-decoration" "underline" ]
            [ Html.text <| "Pre-Scout screen:   " ++ model.driverStation ]
        , Html.div []
            [ inputs "Scouter's name:" NameInput model.scouter
            , inputs "Team's number:" TeamInput model.team
            , inputs "Match number:" MatchInput model.match
            ]
        , startButton model
        ]


confirmationView : StrModel -> Html.Html Msg
confirmationView model =
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
        , startButton model
        ]
