module Scripts exposing
    ( scripts
    )

import Html exposing (..)
import Dict exposing (Dict)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common exposing (..)

quote : String -> String
quote s = "\"" ++ s ++ "\""

-- TODO: move the alias functions to their own file once the tf2
-- scriptgen api grows.

-- all double quotes in `n` or `v` are replaced with single-quotes
alias : String -> String -> String
alias n v =
    let rq = String.replace "\"" "'"
    in
    "alias \"" ++ rq n ++ "\" \"" ++ rq v ++ "\""

-- marginally less safe version of `alias` which doesn't wrap
-- its arguments in quotes
alias_ : String -> String -> String
alias_ n v =
    let rq = String.replace "\"" "'"
    in
    "alias " ++ rq n ++ " " ++ rq v

getoptWarn : Dict String String -> String -> String
getoptWarn opts opt = 
    let warning = "puppy.tf: unset option: '" ++ opt ++ "'"
    in
    case Dict.get opt opts of
        Nothing -> warning
        Just "" -> warning
        Just o  -> o

getopt : Dict String String -> String -> String
getopt opts opt = Maybe.withDefault ""
    <| Dict.get opt opts

mklines : List String -> String
mklines = List.foldr (\a b -> a ++ "\n" ++ b) ""

keybtn : Html msg
keybtn =
    div [ class "keybtn" ]
    [ button
        [ class "ask-key"
        ]
        []
    , input
        [ class "key-name"
        , type_ "text"
        , placeholder "key"
        ]
        []
    ]


scripts : Dict String String -> List (ScriptInfo Msg)
scripts scriptopts =
    let opt html = div [ class "script-options" ] html in
{-----------------------------------------------------------------------------------------}
    [ ScriptInfo "Automatic Crouch Jump"
                 "automatically crouch whenever you jump"
                 allClasses
                 (\opts ->
                     mklines
                        [ alias "+crouch_jump"  "+jump; +duck"
                        , alias "-crouch_jump"  "-jump; -duck"
                        ]
                 )
                 [ (Just "jump", "+crouch_jump")
                 ]
                 <| opt []
{-----------------------------------------------------------------------------------------}
    , ScriptInfo "Übercharge Alert"
                 "send a message notifying your team whenever you use Übercharge"
                 [Medic]
                 (\opts ->
                    alias_ "uber_alert"
                        ("say_team " ++ getoptWarn opts "uber-alert:message")
                 )
                 [ (Just "medic-use", "uber_alert")
                 ]
                 <| opt
                     [ input
                         [ type_ "text"
                         , placeholder "alert message"
                         , onInput <| ScriptOption "uber-alert:message"
                         , value <| getopt scriptopts "uber-alert:message"
                         ]
                         []
                     ]
{-----------------------------------------------------------------------------------------}
    , ScriptInfo "No-Drop"
                 "switch to your Medi-gun and drop the intelligence when you attempt to use Über"
                 [Medic]
                 (\opts ->
                     alias "no-drop" "slot2; dropitem"
                 )
                 [ (Just "medic-use", "no-drop")
                 ]
                 <| opt []
{-----------------------------------------------------------------------------------------}
    , ScriptInfo "Quick Teleport"
                 "blah"
                 [Engineer]
                 (\opts ->
                     -- TODO: add an option to change which destination
                     -- is selected by the modifier bind, and which is by
                     -- the unmodified bind
                     -- or just allow creating modifier binds for
                     -- anything that needs to be bound.
                     mklines
                     [ alias "quick_teleport" "_tp_spawn"
                     , alias "_tp_spawn" "eureka_teleport 0"
                     , alias "_tp_exit"  "eureka_teleport 1"
                     , alias "+change_tp" <| alias_ "quick_teleport" "_tp_exit"
                     , alias "-change_tp" <| alias_ "quick_teleport" "_tp_spawn"
                     ]
                 )
                 []
                 <| opt []
{-----------------------------------------------------------------------------------------}
    ]

