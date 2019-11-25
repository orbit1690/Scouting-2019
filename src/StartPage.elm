module StartPage exposing (..)

import Browser
import Html exposing (Attribute, Html, button, div, input, pre, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { name : String
    , team : String
    , matchNumber : String
    , driverPos : String
    , text : String
    }


init : Model
init =
    { name = "", team = "", matchNumber = "", driverPos = "", text = "" }


type Msg
    = Name String
    | Team String
    | MatchNumber String
    | DriverStation String
    | Text String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name newName ->
            { model | name = newName }

        Team newTeam ->
            { model | team = newTeam }

        MatchNumber newStation ->
            { model | matchNumber = newStation }

        DriverStation newStation ->
            { model | driverPos = newStation }

        Text newText ->
            if model.name == "" || model.team == "" || model.matchNumber == "" || model.driverPos == "" then
                { model | text = "Error" }

            else
                { model | text = "" }


view : Model -> Html Msg
view model =
    pre []
        [ Html.text " Scouter's name "
        , input [ value model.name, onInput Name ] []
        , Html.text "\n\n Scouted team number "
        , input [ value model.team, onInput Team ] []
        , Html.text "\n\n Match number "
        , input [ value model.matchNumber, onInput MatchNumber ] []
        , Html.text "\n\n Scouted team driver station position "
        , input [ value model.driverPos, onInput DriverStation ] []
        , Html.text "\n\n               "
        , button [ onClick <| Text "Error" ] [ text "Enter" ]
        , div [ style "color" "red" ] [ text <| "                " ++ model.text ]
        ]
