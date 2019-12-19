module Scouting exposing (Model, Msg, init, update, view)

import Browser
import Html
import Html.Attributes as Attributes
import Html.Events as Events


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type Msg
    = NewTeam String
    | NewScouter String
    | NewGame String
    | Validate


type alias Model =
    { team : String
    , scouter : String
    , game : String
    , button : Bool
    }


init : Model
init =
    { team = ""
    , scouter = ""
    , game = ""
    , button = False
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewTeam team ->
            { model | team = team }

        NewScouter scouter ->
            { model | scouter = scouter }

        NewGame game ->
            { model | game = game }

        Validate ->
            { model | button = True }


view : Model -> Html.Html Msg
view model =
    if model.button then
        Html.div []
            [ Html.div []
                [ Html.text ("Scouter name " ++ model.scouter)
                ]
            , Html.div []
                [ Html.text ("Team number " ++ model.team ++ ", playing game " ++ model.game)
                ]
            ]

    else
        Html.div []
            [ Html.div []
                [ Html.input
                    [ Attributes.placeholder "Enter scouter name"
                    , Events.onInput NewScouter
                    ]
                    []
                ]
            , Html.div [ Attributes.style "margin-top" "10px" ]
                [ Html.input
                    [ Attributes.type_ "number"
                    , Attributes.placeholder "Enter team number"
                    , Events.onInput NewTeam
                    ]
                    []
                ]
            , Html.div [ Attributes.style "margin-top" "10px" ]
                [ Html.input
                    [ Attributes.type_ "number"
                    , Attributes.placeholder "Enter game number"
                    , Events.onInput NewGame
                    ]
                    []
                ]
            , Html.div [ Attributes.style "margin-top" "10px" ]
                [ Html.button [ Events.onClick Validate ]
                    [ Html.text "start game"
                    ]
                ]
            ]
