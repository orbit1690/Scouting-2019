module Matches exposing (asComment, stationString)

import List.Extra exposing (elemIndex, getAt)
import Maybe exposing (withDefault)
import String


type alias Alliance =
    { one : Int
    , two : Int
    , three : Int
    }


type alias Match =
    { blue : Alliance
    , red : Alliance
    }


matches : List Match
matches =
    [ { blue = { one = 1690, two = 1574, three = 3339 }, red = { one = 254, two = 2056, three = 1323 } }
    , { blue = { one = 118, two = 1577, three = 1024 }, red = { one = 2056, two = 1690, three = 254 } }
    , { blue = { one = 1574, two = 3339, three = 1577 }, red = { one = 1323, two = 1024, three = 118 } }
    , { blue = { one = 3339, two = 1574, three = 1577 }, red = { one = 1024, two = 118, three = 2056 } }
    ]


getMatch : Maybe Int -> Match
getMatch match =
    -- == {blue = {one = team1, two = team2, three = team3}, red = {one = team4, two = team5, three = team6}}
    withDefault { blue = { one = 0, two = 0, three = 0 }, red = { one = 0, two = 0, three = 0 } } <|
        getAt (withDefault 0 match) matches


stationIndex : Maybe Int -> Maybe Int -> String
stationIndex team match =
    -- team2 -> index = 2
    -- unwrapToString << elemIndex (withDefault 0 team) << getMatch <| withDefault 0 match - 1
    -- withDefault "" String.fromInt (getMatch match)
    case getMatch.match of
        blue ->
            "1"

        red ->
            "2"


stationString : Maybe Int -> Maybe Int -> String
stationString team match =
    -- Gets model.team and model.match from update, and calls stationIndex
    case stationIndex team match of
        "0" ->
            "כחול 1"

        "1" ->
            "כחול 2"

        "2" ->
            "כחול 3"

        "3" ->
            "אדום 1"

        "4" ->
            "אדום 2"

        "5" ->
            "אדום 3"

        _ ->
            ""


asComment : String
asComment =
    "match1 = [ 1690, 1574, 3339 || 254, 2056, 1323 ]\n\nmatch2 = [ 118,  1577, 1024 || 2056, 1690, 254 ]\n\nmatch3 = [ 1574, 3339, 1577 || 1323, 1024, 118 ]\n\nmatch4 = [ 3339, 1574, 1577 || 1024, 118, 2056 ]\n\n"
