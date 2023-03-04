module Binds exposing (..)

import Dict exposing (Dict)
import Common exposing (..)
import Set exposing (Set)

defaultBinds : Dict TF2Key String
defaultBinds = Dict.fromList
    -- https://wiki.teamfortress.com/w/images/c/c8/Config_default.cfg.txt
    [ ("`",           "toggleconsole")
    , ("w",           "+forward")
    , ("s",           "+back")
    , ("a",           "+moveleft")
    , ("d",           "+moveright")
    , ("SPACE",       "+jump")
    , ("CTRL",        "+duck")
    , ("TAB",         "+showscores")
    , ("'",           "+moveup")
    , ("/",           "+movedown")
    , ("PGUP",        "+lookup")
    , ("PGDN",        "+lookdown")
    , ("END",         "centerview")
    , ("ALT",         "+strafe")
    , ("INS",         "+klook")
    -- , ("SEMICOLON",   "+mlook") -- commented in source
    , ("r",           "+reload")
    , ("MOUSE1",      "+attack")
    , ("MOUSE2",      "+attack2")
    , ("MOUSE3",      "+attack3")
    -- , ("z",           "saveme") -- comment in source
    , ("z",           "voice_menu_1")
    , ("x",           "voice_menu_2")
    , ("c",           "voice_menu_3")
    , ("e",           "dropitem")
    , ("1",           "slot1")
    , ("2",           "slot2")
    , ("3",           "slot3")
    , ("4",           "slot4")
    , ("5",           "slot5")
    , ("6",           "slot6")
    , ("7",           "slot7")
    , ("8",           "slot8")
    , ("9",           "slot9")
    , ("0",           "slot10")
    , ("MWHEELUP",    "invprev")
    , ("MWHEELDOWN",  "invnext")
    , ("q",           "lastinv")
    , ("F5",          "screenshot")
    , ("F6",          "save_replay")
    , ("F7",          "abuse_report_queue")
    , ("F10",         "quit prompt")
    , ("F12",         "replay_togglereplaytips")
    , ("PAUSE",       "pause")
    , ("ESCAPE",      "escape")
    , ("t",           "impulse 201")
    , ("y",           "say")
    , ("u",           "say_team")
    , ("v",           "+voicerecord")
    , (".",           "changeteam")
    , (",",           "changeclass")
    , ("F1",          "+showroundinfo")
    , ("g",           "+taunt")
    , ("h",           "+use_action_slot_item")
    , ("e",           "voicemenu 0 0")
    , ("b",           "lastdisguise")
    , ("l",           "dropitem")
    , ("i",           "showmapinfo")
    , ("-",           "disguiseteam")
    , ("m",           "open_charinfo_direct")
    , ("n",           "open_charinfo_backpack")
    , ("f",           "inspect")
    , ("j",           "cl_trigger_first_notification")
    ]

-- OPTIMISATION: replace with our own binary tree, which travels
-- in parallel to whats being compared against
bindableKeys : Set TF2Key
bindableKeys = Set.fromList
    [ "'"
    , ","
    , "-"
    , "."
    , "/"
    , "0"
    , "1"
    , "2"
    , "3"
    , "4"
    , "5"
    , "6"
    , "7"
    , "8"
    , "9"
    , "="
    , "A"
    , "ALT"
    , "B"
    , "BACKSPACE"
    , "C"
    , "CAPSLOCK"
    , "CTRL"
    , "D"
    , "DEL"
    , "DOWNARROW"
    , "E"
    , "END"
    , "ENTER"
    , "ESCAPE"
    , "F"
    , "F1"
    , "F10"
    , "F11"
    , "F12"
    , "F2"
    , "F3"
    , "F4"
    , "F5"
    , "F6"
    , "F7"
    , "F8"
    , "F9"
    , "G"
    , "H"
    , "HOME"
    , "I"
    , "INS"
    , "J"
    , "K"
    , "KP_5"
    , "KP_DEL"
    , "KP_DOWNARROW"
    , "KP_END"
    , "KP_ENTER"
    , "KP_HOME"
    , "KP_INS"
    , "KP_LEFTARROW"
    , "KP_MINUS"
    , "KP_MULTIPLY"
    , "KP_PGDN"
    , "KP_PGUP"
    , "KP_PLUS"
    , "KP_RIGHTARROW"
    , "KP_SLASH"
    , "KP_UPARROW"
    , "L"
    , "LEFTARROW"
    , "LWIN"
    , "M"
    , "MOUSE1"
    , "MOUSE2"
    , "MOUSE3"
    , "MOUSE4"
    , "MOUSE5"
    , "MWHEELDOWN"
    , "MWHEELUP"
    , "N"
    , "NUMLOCK"
    , "O"
    , "P"
    , "PGDN"
    , "PGUP"
    , "Q"
    , "R"
    , "RALT"
    , "RCTRL"
    , "RIGHTARROW"
    , "RSHIFT"
    , "RWIN"
    , "S"
    , "SCROLLLOCK"
    , "SEMICOLON"
    , "SHIFT"
    , "SPACE"
    , "T"
    , "TAB"
    , "U"
    , "UPARROW"
    , "V"
    , "W"
    , "X"
    , "Y"
    , "Z"
    , "["
    , "\\"
    , "]"
    , "`"
    ]

