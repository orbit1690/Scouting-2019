module TeamsDriverStationDict exposing (..)


driverStationInfo : { match1 : Model, match2 : Model, match3 : Model }
driverStationInfo =
    { match1 =
        { stations = { blue1 = 1, blue2 = 2, blue3 = 3, red1 = 4, red2 = 5, red3 = 6 } }
    , match2 =
        { stations = { blue1 = 7, blue2 = 8, blue3 = 9, red1 = 10, red2 = 11, red3 = 12 } }
    , match3 =
        { stations = { blue1 = 13, blue2 = 14, blue3 = 15, red1 = 16, red2 = 17, red3 = 18 } }
    }


type alias Model =
    { stations : { blue1 : Int, blue2 : Int, blue3 : Int, red1 : Int, red2 : Int, red3 : Int } }
