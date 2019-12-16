module Scouting exposing (Model, Msg, init, main, update, view)

import Auto
import Browser
import Element exposing (column, el, fill, layout, rgba, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (button, labelBelow, placeholder, username)
import InputHelper exposing (inputs, unwrapToString)
import Matches exposing (asComment, stationName)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = layout [] << view
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
    if List.any ((==) "" << (|>) modelStr) [ .scouter, .team, .match ] then
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


startButton : StrModel -> Element.Element Msg
startButton model =
    let
        ifStarted : String -> String -> String
        ifStarted ifYes ifNo =
            if model.isStarted == Pushed then
                ifYes

            else
                ifNo
    in
    column [ Font.color (rgba 255 0 0 1) ]
        [ button
            [ Background.color (rgba 0 0 0 0.4)
            , Font.color (rgba 1 1 1 1)
            , Border.rounded 3
            , width <| Element.px 50
            ]
            { onPress = Just Start
            , label = text <| ifStarted "Startn't" "Start"
            }
        , text
            << ifStarted ""
          <|
            inputHelpMessage model.driverStation
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


view : Model -> Element.Element Msg
view model =
    {-
       if model.isStarted == Pushed then
           confirmationView <| strModel model

       else
    -}
    registryView <| strModel model


registryView : StrModel -> Element.Element Msg
registryView model =
    column
        [ Font.color (rgba 1 1 1 1)
        , Element.padding 4
        , spacing 10
        ]
        [ inputs "Scouter's name:" NameInput model.scouter
        , inputs "Team's number:" TeamInput model.team
        , inputs "Match number:" MatchInput model.match
        , startButton model
        ]



{-
   confirmationView : StrModel -> Element.Element Msg
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
-}
