module TeamDataView exposing (Model, Msg, init, subscriptions, update, view)

import Colors exposing (black, blue, pink, red, sky, white, yellow)
import Element exposing (centerX, centerY, column, fill, height, minimum, padding, px, spacing, width)
import Element.Background as Background
import Element.Border as Border exposing (widthXY)
import Element.Font as Font exposing (center)
import Element.Input as Input exposing (labelHidden)
import GetMatch exposing (getMatch, maybeIntToInt, unwrapToString)
import Http
import Maybe
import String


type Msg
    = ScouterInput String
    | TeamInput String
    | MatchInput String


type alias Model =
    { scouterName : String
    , team : Maybe Int
    , match : Maybe Int
    }


teamDataView : Model -> Element.Element Msg
teamDataView model =
    column
        [ Background.color sky
        , Border.color black
        , padding 50
        , spacing 20
        , widthXY 5 5
        , centerX
        , centerY
        ]
        [ checkbox model.scouterName ScouterInput "Scouter's name"
        , checkbox (unwrapToString model.team) TeamInput "Scouted team number"
        , checkbox (unwrapToString model.match) MatchInput "Match number"
        , Element.el
            [ Background.gradient
                { angle = 3
                , steps = [ red, pink, yellow ]
                }
            , width (fill |> minimum 350)
            , height fill
            , center
            , Font.color white
            , Font.glow blue 5
            , Font.size 20
            , Font.family
                [ Font.external
                    { name = "Pacifico"
                    , url = "https://fonts.googleapis.com/css?family=Pacifico"
                    }
                ]
            ]
            (Element.text <| getMatch model.team model.match)
        ]


checkbox : String -> (String -> Msg) -> String -> Element.Element Msg
checkbox modelValue nextButton name =
    Input.text
        [ Font.color sky
        , Font.size 20
        , height fill
        , Font.family
            [ Font.external
                { name = "Pacifico"
                , url = "https://fonts.googleapis.com/css?family=Pacifico"
                }
            ]
        ]
        { onChange = nextButton
        , text = modelValue
        , placeholder = Just <| Input.placeholder [] (Element.text name)
        , label = labelHidden modelValue
        }


init : String -> Maybe Int -> Maybe Int -> Model
init sN tN mN =
    Model sN mN tN


update : Msg -> Model -> Model
update msg model =
    case msg of
        ScouterInput s ->
            { model | scouterName = s }

        TeamInput s ->
            { model | team = String.toInt s }

        MatchInput s ->
            { model | match = String.toInt s }


view : Model -> Element.Element Msg
view model =
    teamDataView model


subscriptions : Sub Msg
subscriptions =
    Sub.none
