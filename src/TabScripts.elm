module TabScripts exposing
    ( ScriptInfo
    , scripts
    , tabHTML
    , TFConfig
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
    , scriptSource : String
    , classes : List Tf2.Class -- give me my fucking typeclasses back i beg. i wanted to use `Set`
    }

type alias TFConfig =
    { scripts : Set String
    }

scripts : List ScriptInfo
scripts =
    [ ScriptInfo "Automatic Crouch Jump"
                 "automatically crouch whenever you jump"
                 ""
                 ""
                 allClasses
    , ScriptInfo "Übercharge Alert"
                 "send a message notifying your team whenever you use your Übercharge"
                 ""
                 ""
                 [Medic]
    , ScriptInfo "Dropping is Bad"
                 "switch to your Medi-gun and drop the intelligence when you attempt to use Über"
                 ""
                 ""
                 [Medic]
    , ScriptInfo "Quick Teleport"
                 "blah"
                 ""
                 ""
                 [Engineer]
    ]

-- tabHTML : Html msg
tabHTML = div [ class "scripts-container" ] <| List.map viewScriptInfo scripts

-- viewScriptInfo : ScriptInfo -> Html msg
viewScriptInfo sc =
    div [ class "script-info" ]
    [ div [ class "preview" ]
        []
    , div [ class "info" ]
        [ div [ class "top-container" ]
            [ p [ class "name" ] [ text sc.name ]
            , button [ onClick <| AddScript sc.name ] [ text "add" ]
            ]
        , p [ class "desc" ] [ text sc.desc ]
        ]
    ]

