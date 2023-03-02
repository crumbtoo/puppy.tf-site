module TabScripts exposing
    ( tabHTML
    , genScript
    , genBinds
    )

import Dict exposing (..)
import Set exposing (..)
import Set.Any as SA exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common exposing (..)
import Scripts exposing (scripts)

tabHTML : AnySet String (ScriptInfo Msg) -> Dict String String -> Html Msg
tabHTML scripts opts = div [ class "scripts-container" ]
    <| List.map (viewScriptInfo scripts) (Scripts.scripts opts)

viewScriptInfo : AnySet String (ScriptInfo Msg) -> ScriptInfo Msg -> Html Msg
viewScriptInfo scriptset sc =
    let isEnabled = SA.member sc scriptset in
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
            , button [ class "addbtn", onClick <| ToggleScript sc ] [ text "add" ]
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
        
genBinds : AnySet String (ScriptInfo msg) -> Dict String String -> String
genBinds scripts opts = ""
