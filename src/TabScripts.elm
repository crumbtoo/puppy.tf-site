module TabScripts exposing
    ( ScriptInfo
    , scripts
    , tabHTML
    )

import Tf2 exposing (..)
import Set exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common exposing (..)


type alias ScriptInfo =
    { prettyName : String
    , desc : String
    , name : String -- internal name
    , classes : List Tf2.Class -- give me my fucking typeclasses back i beg. i wanted to use `Set`
    }

scripts : List ScriptInfo
scripts =
    [ ScriptInfo "Automatic Crouch Jump"
                 "automatically crouch whenever you jump"
                 "crouch-jump"
                 allClasses
    , ScriptInfo "Übercharge Alert"
                 "send a message notifying your team whenever you use your Übercharge"
                 "uber-alert"
                 [Medic]
    , ScriptInfo "Dropping is Bad"
                 "switch to your Medi-gun and drop the intelligence when you attempt to use Über"
                 "no-drop"
                 [Medic]
    , ScriptInfo "Quick Teleport"
                 "blah"
                 "quick-teleport"
                 [Engineer]
    ]

tabHTML : Set String -> Html Msg
tabHTML set = div [ class "scripts-container" ] <| List.map (viewScriptInfo set) scripts

viewScriptInfo : Set String -> ScriptInfo -> Html Msg
viewScriptInfo scriptset sc =
    -- let idstr = String.fromInt <| sc.id in
    div
        [ classList
            [ ("script-info", True)
            , ("active", Set.member sc.name scriptset)
            ] 
        , onClick <| AddScript sc.name
        ]
    [ div [ class "preview" ]
        []
    , div
        [ class "info" ]
        [ div [ class "top-container" ]
            [ p [ class "name" ] [ text sc.prettyName ]
            ]
        , p [ class "desc" ] [ text sc.desc ]
        ]
    ]

