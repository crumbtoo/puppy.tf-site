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

type alias ScriptInfo msg =
    { prettyName : String
    , desc : String
    , name : String -- internal name
    , classes : List Tf2.Class -- give me my fucking typeclasses back i beg. i wanted to use `Set`
    , options : Html msg
    }

scripts : List (ScriptInfo Msg)
scripts =
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
                 <| opt []
    ]

tabHTML : Set String -> Html Msg
tabHTML set = div [ class "scripts-container" ] <| List.map (viewScriptInfo set) scripts

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

