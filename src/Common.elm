module Common exposing (..)

import Browser exposing (..)
import Browser.Navigation as Nav
import Url
import Set exposing (..)
import Dict exposing (..)
import Set.Any exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type alias ScriptInfo msg =
    { prettyName : String
    , desc : String
    , name : String -- internal name
    , classes : List Class -- give me my fucking typeclasses back i beg. i wanted to use `Set`
    , generate : (Dict String String -> String)
    -- , binds : Set String -- list of aliases needing binds
    , options : Html msg
    }

type alias Config msg =
    { scripts : AnySet String (ScriptInfo msg)
    , scriptOpts : Dict String String
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

-- classToInt : Class -> Int
-- classToInt c =
--     case c of
--         Scout        -> 1
--         Soldier      -> 2
--         Pyro         -> 3
--         Demoman      -> 4
--         Heavyweapons -> 5
--         Engineer     -> 6
--         Medic        -> 7
--         Sniper       -> 8
--         Spy          -> 9

compareScript : ScriptInfo msg -> String
compareScript = .name

type Msg = LinkClicked Browser.UrlRequest
         | UrlChanged Url.Url
         | ToggleScript (ScriptInfo Msg)
         | ScriptOption String String
