module TeamDataView exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (button, div, fieldset, input, label, text)
import Html.Attributes as Attributes exposing (checked, name, placeholder, style, type_, value)
import Html.Events as Events exposing (onClick, onInput)
import Http
import Json.Decode
import PrimaryModules exposing (Position)
import String


type Color
    = Red
    | Blue


type Msg
    = ScouterInput String
    | TeamInput String
    | MatchInput String
    | DriverStationPositionInput Color Position


type alias Model =
    { scouterName : String
    , team : Int
    , match : Int
    , driverStationPosition : String
    }


teamDataView : Model -> Html.Html Msg
teamDataView model =
    Html.pre []
        [ checkbox model.scouterName ScouterInput "Scouter's name"
        , checkbox (String.fromInt model.team) TeamInput "Scouted team number"
        , checkbox (String.fromInt model.match) MatchInput "Match number"
        , enumList model
        ]


checkbox : String -> (String -> Msg) -> String -> Html.Html Msg
checkbox modelValue nextButton name =
    div []
        [ input [ placeholder name, onInput nextButton, value modelValue ] [] ]


enumList : Model -> Html.Html Msg
enumList model =
    div []
        [ fieldset []
            [ enumProperty (model.driverStationPosition == 1 Red) 1 Red ""
            , enumProperty (model.driverStationPosition == 2 Red) 2 Red ""
            , enumProperty (model.driverStationPosition == 3 Red) 3 Red
            , enumProperty (model.driverStationPosition == 1 Blue) 1 Blue
            , enumProperty (model.driverStationPosition == 2 Blue) 2 Blue
            , enumProperty (model.driverStationPosition == 3 Blue) 3 Blue
            ]
        ]


enumProperty : Bool -> Position -> Color -> String -> Html.Html Msg
enumProperty isChecked position color name =
    label
        [ style "padding" "2%" ]
        [ input [ type_ "radio", placeholder name, onInput <| DriverStationPositionInput color position, checked isChecked ] []
        , text name
        ]


init : String -> String -> Int -> Int -> Model
init sN dSP tN mN =
    Model sN dSP mN tN


update : Msg -> Model -> Model
update msg model =
    case msg of
        ScouterInput s ->
            { model | scouterName = s }

        TeamInput s ->
            { model | team = Maybe.withDefault 0 <| String.toInt s }

        MatchInput s ->
            { model | match = Maybe.withDefault 0 <| String.toInt s }

        DriverStationPositionInput color position ->
            { model | driverStationPosition = color position }


view : Model -> Html.Html Msg
view model =
    teamDataView model


subscriptions : Sub Msg
subscriptions =
    Sub.none
