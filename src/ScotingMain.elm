module ScotingMain exposing (Model, Msg)

import Bool
import Browser
import Debug
import Html exposing (button, div, text)
import Html.Attributes as Attributes
import Html.Events as Events exposing (onClick)
import Http
import Json.Decode
import String


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always subscriptions
        }


type Msg
    = TeamToAutonomiBoutton

type Model 
    = TeamMode
    | AutonomiMode

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TeamToAutonomiBoutton ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        TeamMode ->

        AutonomiMode ->
        


subscriptions : Sub Msg
subscriptions =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( TeamMode, Cmd.none )
