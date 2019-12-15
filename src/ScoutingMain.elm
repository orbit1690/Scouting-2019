module ScoutingMain exposing (Model, Msg, init, subscriptions, update, view)

import AutonomousDataView
import Browser
import Colors exposing (black, blue, blueGreen, lightBlue, orange, purple, sky, white)
import Debug
import Element exposing (centerX, centerY, column, fill, height, layout, maximum, padding, rgb255, shrink, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input exposing (button)
import GetMatch exposing (getMatch, maybeIntToInt, unwrapToString)
import Http
import Maybe
import String
import TeamDataView


main : Program () Model Msg
main =
    Browser.element
        { init = always ( init, Cmd.none )
        , view = view >> layout []
        , update = \msg model -> ( update msg model, Cmd.none )
        , subscriptions = subscriptions
        }


type Pages
    = Page1
    | Page2


type Msg
    = TeamDataMsg TeamDataView.Msg
    | AutonomousDataMsg AutonomousDataView.Msg
    | NextPage1To2


type alias Model =
    { teamData : TeamDataView.Model
    , autonomousData : AutonomousDataView.Model
    , pages : Pages
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        TeamDataMsg tmsg ->
            { model | teamData = TeamDataView.update tmsg model.teamData }

        AutonomousDataMsg amsg ->
            { model | autonomousData = AutonomousDataView.update amsg model.autonomousData }

        NextPage1To2 ->
            { model | pages = Page2 }


view : Model -> Element.Element Msg
view model =
    case model.pages of
        Page1 ->
            column
                [ Background.color lightBlue
                , Border.color black
                , padding 10
                , spacing 10
                , width fill
                , height fill
                ]
                [ Element.map TeamDataMsg <|
                    TeamDataView.view model.teamData
                , button
                    [ Font.color white
                    , Font.size 40
                    , Font.glow blue 5
                    , Font.family
                        [ Font.external
                            { name = "Pacifico"
                            , url = "https://fonts.googleapis.com/css?family=Pacifico"
                            }
                        ]
                    , Background.gradient
                        { angle = 2
                        , steps = [ purple, orange, blueGreen ]
                        }
                    , center
                    , centerX
                    , centerY
                    , width (fill |> maximum 350)
                    ]
                    { onPress = Just <| NextPage1To2
                    , label = Element.text "Next Page"
                    }
                ]

        Page2 ->
            Element.map AutonomousDataMsg <| AutonomousDataView.view model.autonomousData


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map AutonomousDataMsg <| AutonomousDataView.subscriptions
        , Sub.map TeamDataMsg <| TeamDataView.subscriptions
        ]


init : Model
init =
    { teamData = TeamDataView.init "" Nothing Nothing
    , autonomousData = AutonomousDataView.init "" Nothing Nothing
    , pages = Page1
    }
