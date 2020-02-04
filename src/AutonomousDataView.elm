module AutonomousDataView exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (column)
import Element.Font as Font
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


autonomousDataView : Model -> Element.Element Msg
autonomousDataView model =
    column []
        [ checkbox model.scouterName ScouterInput "test"
        , checkbox (unwrapToString model.team) TeamInput "test"
        , checkbox (unwrapToString model.match) MatchInput "test"
        , Element.text <| getMatch model.team model.match
        ]


checkbox : String -> (String -> Msg) -> String -> Element.Element Msg
checkbox modelValue nextButton name =
    Input.text []
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
    autonomousDataView model


subscriptions : Sub Msg
subscriptions =
    Sub.none
