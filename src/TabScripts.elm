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
    { name : String
    , desc : String
    , previewURL : String
    , classes : List Tf2.Class -- give me my fucking typeclasses back i beg. i wanted to use `Set`
    , id : Int
    }

scripts : List ScriptInfo
scripts =
    [ ScriptInfo "Automatic Crouch Jump"
                 "automatically crouch whenever you jump"
                 ""
                 allClasses
                 0
    , ScriptInfo "Übercharge Alert"
                 "send a message notifying your team whenever you use your Übercharge"
                 ""
                 [Medic]
                 1
    , ScriptInfo "Dropping is Bad"
                 "switch to your Medi-gun and drop the intelligence when you attempt to use Über"
                 ""
                 [Medic]
                 2
    , ScriptInfo "Quick Teleport"
                 "blah"
                 ""
                 [Engineer]
                 3
    ]

tabHTML : Set Int -> Html Msg
tabHTML set = div [ class "scripts-container" ] <| List.map (viewScriptInfo set) scripts

viewScriptInfo : Set Int -> ScriptInfo -> Html Msg
viewScriptInfo scriptset sc =
    -- let idstr = String.fromInt <| sc.id in
    div
        [ classList
            [ ("script-info", True)
            , ("active", Set.member sc.id scriptset)
            ] 
        , onClick <| AddScript sc.id
        ]
    [ div [ class "preview" ]
        []
    , div
        [ class "info" ]
        [ div [ class "top-container" ]
            [ p [ class "name" ] [ text sc.name ]
            ]
        , p [ class "desc" ] [ text sc.desc ]
        ]
    ]

