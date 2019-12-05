module Matches exposing (asComment, driverStations)

import String


driverStations : List (List Int)
driverStations =
    [ [ 1690, 1574, 3339, 254, 2056, 1323 ]
    , [ 118, 1577, 1024, 2056, 1690, 254 ]
    , [ 1574, 3339, 1577, 1323, 1024, 118 ]
    , [ 3339, 1574, 1577, 1024, 118, 2056 ]
    ]


asComment : String
asComment =
    "match1 = [ 1690, 1574, 3339 || 254, 2056, 1323 ]\n\nmatch2 = [ 118,  1577, 1024 || 2056, 1690, 254 ]\n\nmatch3 = [ 1574, 3339, 1577 || 1323, 1024, 118 ]\n\nmatch4 = [ 3339, 1574, 1577 || 1024, 118, 2056 ]\n\n"
