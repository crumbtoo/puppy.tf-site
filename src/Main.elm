module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }

type alias Model =
    { tabno : Int
    }


init : Model
init = Model 0

type Msg = TabChange Int

update : Msg -> Model -> Model
update msg model =
    case msg of
        TabChange tabno ->
            { model | tabno = tabno }

view : Model -> Html Msg
view model =
    div []
    [ div [ class "makecfg-tabs" ]
      [ viewTabButton 0
      , viewTabButton 1
      , viewTabButton 2
      , viewTabButton 3
      , viewTab model.tabno
      ]
    ]

viewTabButton : Int -> Html Msg
viewTabButton newtabno =
    input
    [ type_ "radio"
    , name "tabs"
    , value (String.fromInt newtabno)
    , onClick ()
    , checked (if newtabno == 0 then True else False)
    ]
    []

viewTab : Int -> Html msg
viewTab tabno =
    case tabno of
        0 -> div [] [ text "hi" ]
        1 -> div [] [ text "hello" ]
        2 -> div [] [ text "frrrm" ]
        _ -> div [] [ text "naauurr" ]

