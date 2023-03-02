module Scripts exposing
    ( scripts
    )

import Html exposing (..)
import Dict exposing (Dict)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common exposing (..)


mkalias : String -> String -> String
mkalias n v = "alias \"" ++ n ++ "\" \"" ++ v ++ "\"\n"

getopt : Dict String String -> String -> String
getopt opts opt = Maybe.withDefault opt <| Dict.get opt opts

mklines : List String -> String
mklines = List.foldr (++) ""

scripts : List (ScriptInfo Msg)
scripts =
    let opt html = div [ class "script-options" ] html in
{-----------------------------------------------------------------------------------------}
    [ ScriptInfo "Automatic Crouch Jump"
                 "automatically crouch whenever you jump"
                 "crouch-jump"
                 allClasses
                 (\opts ->
                     mklines
                        [ mkalias "+crouch_jump"  "+jump; +duck"
                        , mkalias "-crouch_jump"  "-jump; -duck"
                        ]
                 )
                 <| opt []
{-----------------------------------------------------------------------------------------}
    , ScriptInfo "Übercharge Alert"
                 "send a message notifying your team whenever you use Übercharge"
                 "uber-alert"
                 [Medic]
                 (\opts ->
                    mkalias "uber_alert" ("say_team "
                        ++ getopt opts "uber-alert:message")
                 )
                 <| opt
                     [ input
                         [ type_ "text"
                         , placeholder "alert message"
                         , onInput <| ScriptOption "uber-alert:message"
                         ]
                         []
                     ]
{-----------------------------------------------------------------------------------------}
    , ScriptInfo "No-Drop"
                 "switch to your Medi-gun and drop the intelligence when you attempt to use Über"
                 "no-drop"
                 [Medic]
                 (\opts ->
                     "hi"
                 )
                 <| opt []
    , ScriptInfo "Quick Teleport"
                 "blah"
                 "quick-teleport"
                 [Engineer]
                 (\opts ->
                     "hi"
                 )
                 <| opt
                     [ input
                         [ type_ "text"
                         , placeholder "teleport key"
                         , onInput <| ScriptOption "quick-teleport:tpkey"
                         ]
                         []
                     , input
                         [ type_ "text"
                         , placeholder "modifier"
                         , onInput <| ScriptOption "quick-teleport:modifier"
                         ]
                         []
                     ]
{-----------------------------------------------------------------------------------------}
    ]

