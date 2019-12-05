module TeamDataView exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (button, div, input, label, text)
import Html.Attributes as Attributes exposing (placeholder, style, type_, value)
import Html.Events as Events exposing (onClick, onInput)
import Http
import Json.Decode
import String


type Msg
    = ScouterInput String
    | TeamInput String
    | MatchInput String
    | DriverStationPositionInput String


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
        , checkbox model.driverStationPosition DriverStationPositionInput "Scouted team driver station position"
        ]


checkbox : String -> (String -> Msg) -> String -> Html.Html Msg
checkbox modelValue nextButton name =
    div []
        [ input [ placeholder name, onInput nextButton, value modelValue ] [] ]


checkList : String -> (String -> Msg) -> String -> Html.Html Msg
checkList modelValue nextButton name =
    label
        [ style "padding" "20px" ]
        [ input [ type_ "checkbox", placeholder name, onInput nextButton, value modelValue ] []
        , text name
        ]


init : String -> String -> Int -> Int -> Model
init sN dSP tN mN =
    { scouterName = sN
    , driverStationPosition = dSP
    , match = mN
    , team = tN
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ScouterInput s ->
            { model | scouterName = s }

        TeamInput s ->
            { model | team = Maybe.withDefault 0 <| String.toInt s }

        MatchInput s ->
            { model | match = Maybe.withDefault 0 <| String.toInt s }

        DriverStationPositionInput s ->
            { model | driverStationPosition = s }


view : Model -> Html.Html Msg
view model =
    teamDataView model


subscriptions : Sub Msg
subscriptions =
    Sub.none
