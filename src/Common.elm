module Common exposing (..)

import Browser exposing (..)
import Browser.Navigation as Nav
import Url
import Set exposing (..)
import Dict exposing (..)
import Set.Any exposing (..)
import Dict.Any exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type alias TF2Key = String

type alias TF2Bindings = Dict String String

type alias ScriptInfo msg =
    { name : String
    , desc : String
    , classes : List Class
    , generate : (Dict String String -> String)

    -- first part of this pair is the alias's group. scripts
    -- can share a keybind with scripts in the same group.
    -- ex. +attack2, uber-alert, and no-drop.
    , exportedBinds : List (Maybe String, String) -- list of aliases needing binds
    , options : Html msg
    }

type alias Config msg =
    { scripts : AnySet String (ScriptInfo msg)
    , scriptOpts : Dict String String
    , binds : TF2Bindings
    , classBinds : AnyDict Int Class TF2Bindings
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

compareClass : Class -> Int
compareClass c =
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

compareScript : ScriptInfo msg -> String
compareScript = .name

type Msg = LinkClicked Browser.UrlRequest
         | UrlChanged Url.Url
         | ToggleScript (ScriptInfo Msg)
         | ScriptOption String String

