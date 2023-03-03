module TabBinds exposing
    ( genBinds
    )

import Set.Any as SA exposing (..)
import Dict exposing (Dict)
import Common exposing (..)

genBinds : AnySet String (ScriptInfo msg) -> Dict String String -> String
genBinds scripts opts = ""

-- genInGroup : AnySet String (ScriptInfo Msg) -> String -> Maybe String
-- genInGroup s group = SA.filter (/= []) s.exportedBinds |> 

