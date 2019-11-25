module ScoutingMain exposing (Model, Msg)

import Browser
import Debug
import Html exposing (button, div, input, label, text)
import Html.Attributes as Attributes exposing (style, type_)
import Html.Events as Events exposing (onClick)
import Http
import Json.Decode
import String


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = view
        , update = update
        , subscriptions = always subscriptions
        }


type Msg
    = TeamToAutonomiButton
    | AutonomiToTeleopButton


type alias Inputs =
    { scouterName : String
    , scoutedTeamNumber : String
    , matchNumber : String
    , stationPosition : String
    }


type Model
    = TeamMode
    | AutonomiMode


checkbox : Msg -> String -> Html.Html Msg
checkbox nextButton name =
    label
        [ style "padding" "20px" ]
        [ input [ type_ "checkbox", onClick nextButton ] []
        , text name
        ]


teamDataView : Html.Html Msg
teamDataView =
    div []
        [ input [ placeholder "Scouter's name", value Inputs.scouterName ] []
        , input [ placeholder "Scouted team number", value Inputs.scoutedTeamNumber ] []
        , input [ placeholder "Match number", value Inputs.matchNumber ] []
        , input [ placeholder "Scouted team driver station position", value Inputs.stationPosition ] []
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TeamToAutonomiButton ->
            ( model, Cmd.none )

        AutonomiToTeleopButton ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html.Html Msg
view model =
    case model of
        TeamMode ->
            div []
                [ teamDataView
                , checkbox TeamToAutonomiButton "skip"
                ]

        AutonomiMode ->
            checkbox AutonomiToTeleopButton "none"


subscriptions : Sub Msg
subscriptions =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( TeamMode, Cmd.none )
