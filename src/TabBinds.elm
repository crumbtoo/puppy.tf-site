module TabBinds exposing
    ( genBinds
    , viewTab
    )

import Set.Any as SA exposing (..)
import Dict exposing (Dict)
import Binds
import Common exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import ScriptGen exposing (..)

genBinds : Dict TF2Key String -> AnySet String (ScriptInfo msg) -> String
genBinds binds scripts =
    Dict.foldl (\k v acc -> bind k v :: acc) [] binds
    |> mklines

-- genClassBinds : AnySet String (ScriptInfo msg) -> Class -> String
-- genClassBinds class = 

genGroupBinds : AnySet String (ScriptInfo Msg) -> String -> Maybe String
genGroupBinds set group =
    SA.toList set -- give me typeclasses so i dont have to do this lol
    |> List.map (\sc -> sc.exportedBinds)
    |> (\_ -> Nothing)

viewTab : List (Int, TF2Key, String) -> Html Msg
viewTab pbinds = pbinds
    |> List.map (\ (i,k,v) ->
        div
            [ class "box bind-box"
            ]
            [ input -- TODO: i want to have icons for keys / mouse buttons in the future.
                [ class "key-name"
                , type_ "text"
                , value k
                , onInput <| \x -> UpdateUserBind i x v
                ]
                []
            , input
                [ class "bound-to"
                , type_ "text"
                , value v
                , onInput <| \x -> UpdateUserBind i k x
                ]
                []
            ]
    )
    |> div [ class "binds-container" ]

