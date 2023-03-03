module Scripts exposing
    ( scripts
    )

import Html exposing (..)
import Dict exposing (Dict)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common exposing (..)


-- all double quotes in `n` or `v` are replaced with single-quotes
alias : String -> String -> String
alias n v =
    let rq = String.replace "\"" "'"
    in
    "alias \"" ++ rq n ++ "\" \"" ++ rq v ++ "\"\n"

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
mklines = List.foldr (++) ""

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
                 "crouch-jump"
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
                 "uber-alert"
                 [Medic]
                 (\opts ->
                    alias "uber_alert" ("say_team "
                        ++ getoptWarn opts "uber-alert:message")
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
                 "no-drop"
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
                 "quick-teleport"
                 [Engineer]
                 (\opts ->
                     ""
                 )
                 []
                 <| opt
                     [ input
                         [ type_ "text"
                         , placeholder "teleport key"
                         , onInput <| ScriptOption "quick-teleport:tpkey"
                         , value <| getopt scriptopts "quick-teleport:tpkey"
                         ]
                         []
                     , input
                         [ type_ "text"
                         , placeholder "modifier"
                         , onInput <| ScriptOption "quick-teleport:modifier"
                         , value <| getopt scriptopts "quick-teleport:modifier"
                         ]
                         []
                     ]
{-----------------------------------------------------------------------------------------}
    ]

