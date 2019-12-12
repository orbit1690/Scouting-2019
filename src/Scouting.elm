module Scouting exposing (Model, Msg, init, main, update, view)

import Browser
import Html exposing (input, text)
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Maybe.Extra exposing (unwrap)


inputWriter : String -> (String -> Msg) -> String -> Html.Html Msg
inputWriter placeholderInput msg model =
    Html.div [ style "margin-bottom" "1%" ]
        [ input [ placeholder placeholderInput, onInput msg, value model ]
            []
        ]


unwrapToString : Maybe Int -> String
unwrapToString maybeInt =
    unwrap "" String.fromInt maybeInt


type Pressed
    = Pressed
    | NotPressed
    | InputError


inputChecker : Model -> Model
inputChecker model =
    if model.scoutersName == "" || model.scoutedTeamNumber == Nothing || model.scoutedTeamDriverStationPosition == "" || model.matchNumber == Nothing then
        { model | isPressed = InputError }

    else
        { model | isPressed = Pressed }


type Msg
    = ScoutersNameInput String
    | TeamNumberInput String
    | MatchNumberInput String
    | DriverStationInput String
    | Page Pressed


type alias Model =
    { scoutersName : String
    , scoutedTeamNumber : Maybe Int
    , matchNumber : Maybe Int
    , scoutedTeamDriverStationPosition : String
    , isPressed : Pressed
    }


main : Program () Model Msg
main =
    Browser.element
        { init = always ( init, Cmd.none )
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


init : Model
init =
    { scoutersName = "", scoutedTeamNumber = Nothing, matchNumber = Nothing, scoutedTeamDriverStationPosition = "", isPressed = NotPressed }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ScoutersNameInput name ->
            ( { model | scoutersName = name }, Cmd.none )

        TeamNumberInput name ->
            ( { model | scoutedTeamNumber = String.toInt name }, Cmd.none )

        MatchNumberInput name ->
            ( { model | matchNumber = String.toInt name }, Cmd.none )

        DriverStationInput name ->
            ( { model | scoutedTeamDriverStationPosition = name }, Cmd.none )

        Page state ->
            ( inputChecker model, Cmd.none )


viewWhenPressed : Model -> Html.Html Msg
viewWhenPressed model =
    Html.pre []
        [ inputWriter "your name" ScoutersNameInput model.scoutersName
        , inputWriter "scouted team number" TeamNumberInput << unwrapToString <| model.scoutedTeamNumber
        , inputWriter "match number" MatchNumberInput << unwrapToString <| model.matchNumber
        , inputWriter "driver station position" DriverStationInput model.scoutedTeamDriverStationPosition
        , Html.button [ onClick <| Page Pressed ] [ Html.text "second page" ]
        ]


view : Model -> Html.Html Msg
view model =
    if model.isPressed == Pressed then
        Html.pre []
            [ Html.text model.scoutersName
            , Html.text " your name\n"
            , Html.text (unwrapToString <| model.scoutedTeamNumber)
            , Html.text " scouted team number\n"
            , Html.text (unwrapToString <| model.matchNumber)
            , Html.text " match number\n"
            , Html.text model.scoutedTeamDriverStationPosition
            , Html.text " driver station position\n"
            ]

    else if model.isPressed == InputError then
        Html.div [ style "color" "red" ]
            [ viewWhenPressed model
            , Html.text "all fields are required"
            ]

    else
        viewWhenPressed model
