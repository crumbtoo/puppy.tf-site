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

scripts : List (ScriptInfo msg)
scripts =
    let odiv = div [ class "script-options" ] in
    [ ScriptInfo "Automatic Crouch Jump"
                 "automatically crouch whenever you jump"
                 "crouch-jump"
                 allClasses
                 <| odiv []
    , ScriptInfo "Übercharge Alert"
                 "send a message notifying your team whenever you use Übercharge"
                 "uber-alert"
                 [Medic]
                 <| odiv []
    , ScriptInfo "No-Drop"
                 "switch to your Medi-gun and drop the intelligence when you attempt to use Über"
                 "no-drop"
                 [Medic]
                 <| odiv []
    , ScriptInfo "Quick Teleport"
                 "blah"
                 "quick-teleport"
                 [Engineer]
                 <| odiv []
    ]

tabHTML : Set String -> Html Msg
tabHTML set = div [ class "scripts-container" ] <| List.map (viewScriptInfo set) scripts

viewScriptInfo : Set String -> ScriptInfo Msg -> Html Msg
viewScriptInfo scriptset sc =
    -- let idstr = String.fromInt <| sc.id in
    div
        [ classList
            [ ("script-info", True)
            , ("active", Set.member sc.name scriptset)
            ] 
        , onClick <| ToggleScript sc.name
        ]
    [ div [ class "preview" ]
        []
    , div
        [ class "info" ]
        [ div [ class "top-container" ]
            [ p [ class "name" ] [ text sc.prettyName ]
            ]
        , p [ class "desc" ] [ text sc.desc ]
        , sc.options
        ]
    ]

