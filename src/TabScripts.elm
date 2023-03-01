module TabScripts exposing
    ( ScriptInfo
    , allScripts
    , tabHTML
    , genScript
    , genBinds
    )

import Dict exposing (..)
import Tf2 exposing (..)
import Set exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common exposing (..)

type alias ScriptInfo msg =
    { prettyName : String
    , desc : String
    , name : String -- internal name
    , classes : List Tf2.Class -- give me my fucking typeclasses back i beg. i wanted to use `Set`
    -- , binds : Set String -- list of aliases needing binds
    , options : Html msg
    }

allScripts : List (ScriptInfo Msg)
allScripts =
    let opt html = div [ class "script-options" ] html in
    [ ScriptInfo "Automatic Crouch Jump"
                 "automatically crouch whenever you jump"
                 "crouch-jump"
                 allClasses
                 <| opt []
    , ScriptInfo "Übercharge Alert"
                 "send a message notifying your team whenever you use Übercharge"
                 "uber-alert"
                 [Medic]
                 <| opt
                     [ input
                         [ type_ "text"
                         , placeholder "alert message"
                         , onInput <| ScriptOption "uber-alert:message"
                         ]
                         []
                     ]
    , ScriptInfo "No-Drop"
                 "switch to your Medi-gun and drop the intelligence when you attempt to use Über"
                 "no-drop"
                 [Medic]
                 <| opt []
    , ScriptInfo "Quick Teleport"
                 "blah"
                 "quick-teleport"
                 [Engineer]
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
                         
    ]

tabHTML : Set String -> Html Msg
tabHTML set = div [ class "scripts-container" ] <| List.map (viewScriptInfo set) allScripts

viewScriptInfo : Set String -> ScriptInfo Msg -> Html Msg
viewScriptInfo scriptset sc =
    let isEnabled = Set.member sc.name scriptset in
    div
        [ classList
            [ ("script-info", True)
            , ("active", isEnabled)
            ] 
        ]
    [ div [ class "preview" ]
        []
    , div [ class "info" ]
        [ div [ class "top-container" ]
            [ p [ class "name" ] [ text sc.prettyName ]
            , button [ class "addbtn", onClick <| ToggleScript sc.name] [ text "add" ]
            ]
        , p [ class "desc" ] [ text sc.desc ]
        , sc.options
        ]
    ]

-- elm is so frusterating. this would be 100x safer with
-- typeclasses
genScript : Dict String String -> String -> String
genScript opts scriptID =
    let mkalias n v = "alias \"" ++ n ++ "\" \"" ++ v ++ "\"\n"
        getopt opt = Maybe.withDefault opt <| Dict.get opt opts
        mklines = List.foldr (++) ""
    in
    case scriptID of
        "crouch-jump" -> mklines
            [ mkalias "+crouch_jump"  "+jump; +duck"
            , mkalias "-crouch_jump"  "-jump; -duck"
            ]

        "uber-alert" ->
            mkalias "uber_alert" ("say_team " ++ getopt "uber-alert:message")
        "no-drop" -> "nodop"
        "quick-teleport" -> "quikktp"
        _ -> Debug.todo "sorry bitch! elm has no fucking typeclasses!"
        
genBinds : Set String -> Dict String String -> String
genBinds scripts opts = ""
