module Auto exposing (init, update, view)

import Browser
import Debug
import FunctionList exposing (inputs, unwrapToString)
import Html
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onClick, onInput)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
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
    , isStarted : Bool
    }


init : Model
init =
    { scouter = ""
    , team = Nothing
    , match = Nothing
    , driverStation = ""
    , isStarted = False
    }


view : Model -> Html.Html msg
view model =
    Debug.todo "make view for Auto.elm"



-- TODO: define view


update : Msg -> Model -> Model
update msg model =
    case msg of
        _ ->
            Debug.todo "make update for Auto.elm"
