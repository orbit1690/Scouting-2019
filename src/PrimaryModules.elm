module PrimaryModules exposing (Position, makePosition)


type Position
    = Position Int


makePosition : Int -> Maybe Position
makePosition n =
    if n > 0 && n < 4 then
        Just <| Position n

    else
        Nothing
