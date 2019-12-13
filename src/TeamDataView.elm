module TeamDataView exposing (Model, Msg, init, subscriptions, update, view)

import GetMatch exposing (getMatch, maybeIntToInt, unwrapToString)
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


type alias Model =
    { scouterName : String
    , team : Maybe Int
    , match : Maybe Int
    }


teamDataView : Model -> Html.Html Msg
teamDataView model =
    Html.pre []
        [ checkbox model.scouterName ScouterInput "Scouter's name"
        , checkbox (unwrapToString model.team) TeamInput "Scouted team number"
        , checkbox (unwrapToString model.match) MatchInput "Match number"
        , div [] [ text <| getMatch model.team model.match ]
        ]


checkbox : String -> (String -> Msg) -> String -> Html.Html Msg
checkbox modelValue nextButton name =
    div []
        [ input [ placeholder name, onInput nextButton, value modelValue ] [] ]


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


view : Model -> Html.Html Msg
view model =
    teamDataView model


subscriptions : Sub Msg
subscriptions =
    Sub.none
