module ScriptGen exposing
    ( quote
    , alias
    , alias_
    , mklines
    )

quote : String -> String
quote s = "\"" ++ s ++ "\""

-- TODO: move the alias functions to their own file once the tf2
-- scriptgen api grows.

-- all double quotes in `n` or `v` are replaced with single-quotes
alias : String -> String -> String
alias n v =
    "alias \"" ++ n ++ "\" \"" ++ v ++ "\""

-- marginally less safe version of `alias` which doesn't wrap
-- its arguments in quotes
alias_ : String -> String -> String
alias_ n v =
    "alias " ++ n ++ " " ++ v

mklines : List String -> String
mklines = List.foldr (\a b -> a ++ "\n" ++ b) ""

