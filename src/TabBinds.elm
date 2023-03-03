module TabBinds exposing
    ( genBinds
    , tabHTML
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

tabHTML : Config msg -> Html msg
tabHTML cfg = div [] [ text "uhh...." ]
