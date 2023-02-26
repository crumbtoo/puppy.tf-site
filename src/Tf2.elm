module Tf2 exposing (..)

import Set exposing (..)

type alias Config =
    { scripts : Set Int
    }

type Class = Scout
           | Soldier
           | Pyro
           | Demoman
           | Heavyweapons
           | Engineer
           | Medic
           | Sniper
           | Spy

allClasses : List Class
allClasses = [ Scout, Soldier, Pyro
             , Demoman, Heavyweapons, Engineer
             , Medic, Sniper, Spy
             ]

classToInt : Class -> Int
classToInt c =
    case c of
        Scout        -> 1
        Soldier      -> 2
        Pyro         -> 3
        Demoman      -> 4
        Heavyweapons -> 5
        Engineer     -> 6
        Medic        -> 7
        Sniper       -> 8
        Spy          -> 9

