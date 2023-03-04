module TabScripts exposing
    ( viewTab
    )

import Dict exposing (..)
import Set exposing (..)
import Set.Any as SA exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common exposing (..)
import Scripts exposing (scripts)

viewTab : AnySet String (ScriptInfo Msg) -> Dict String String -> Html Msg
viewTab scripts opts = div [ class "scripts-container" ]
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
            [ p [ class "name" ] [ text sc.name ]
            , button [ class "addbtn", onClick <| ToggleScript sc ] [ text "add" ]
            ]
        , p [ class "desc" ] [ text sc.desc ]
        , sc.options
        ]
    ]

