module ScriptGen exposing
    ( quote
    , mklines
    , alias
    , alias_
    , bind
    , bind_
    )

import Common exposing (TF2Key)

mklines : List String -> String
mklines = List.foldr (\a b -> a ++ "\n" ++ b) ""

quote : String -> String
quote s = "\"" ++ s ++ "\""

-- all double quotes in `n` or `v` are replaced with single-quotes
alias : String -> String -> String
alias n v =
    "alias \"" ++ n ++ "\" \"" ++ v ++ "\""

-- marginally less safe version of `alias` which doesn't wrap
-- its arguments in quotes
alias_ : String -> String -> String
alias_ n v =
    "alias " ++ n ++ " " ++ v

bind : TF2Key -> String -> String
bind k v = "bind " ++ quote k ++ " " ++ quote v

bind_ : TF2Key -> String -> String
bind_ k v = "bind " ++ quote k ++ " " ++ v
