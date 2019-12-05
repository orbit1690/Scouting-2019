module TeamDataView exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (button, div, fieldset, input, label, text)
import Html.Attributes as Attributes exposing (checked, name, placeholder, style, type_, value)
import Html.Events as Events exposing (onClick, onInput)
import Http
import Json.Decode
import String


type Station
    = Red1 String
    | Red2 String
    | Red3 String
    | Blue1 String
    | Blue2 String
    | Blue3 String


type Msg
    = ScouterInput String
    | TeamInput String
    | MatchInput String
    | DriverStationPositionInput String String


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
            [ enumProperty (model.driverStationPosition == "Red1") "Red1"
            , enumProperty (model.driverStationPosition == "Red2") "Red2"
            , enumProperty (model.driverStationPosition == "Red3") "Red3"
            ]
        ]


enumProperty : Bool -> String -> Html.Html Msg
enumProperty isChecked name =
    label
        [ style "padding" "2%" ]
        [ input [ type_ "radio", placeholder name, onInput <| DriverStationPositionInput name, checked isChecked ] []
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
    let
        _ =
            Debug.log "in update" <| Debug.toString msg
    in
    case msg of
        ScouterInput s ->
            { model | scouterName = s }

        TeamInput s ->
            { model | team = Maybe.withDefault 0 <| String.toInt s }

        MatchInput s ->
            { model | match = Maybe.withDefault 0 <| String.toInt s }

        DriverStationPositionInput name isChecked ->
            { model | driverStationPosition = name }


view : Model -> Html.Html Msg
view model =
    teamDataView model


subscriptions : Sub Msg
subscriptions =
    Sub.none
