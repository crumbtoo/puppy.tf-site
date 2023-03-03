module Main exposing (main)

import Browser exposing (..)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Url
import Url.Builder as UB
import Set exposing (..)
import Set.Any as SA exposing (..)
import Dict.Any as DA exposing (..)
import Common exposing (..)
import Dict as D

import TabScripts as TabScripts

type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , config : Common.Config Msg
    }

main : Program () Model Msg
main = Browser.application
       { init = init
       , view = view
       , update = update
       , subscriptions = (\_ -> Sub.none)
       , onUrlChange = UrlChanged
       , onUrlRequest = LinkClicked
       }


init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
    ( Model key url
        <| Common.Config
            (SA.empty Common.compareScript)
            D.empty
            D.empty
    , Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key <| Url.toString url)

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        ToggleScript script -> -- Debug.todo "a"
            let addsc cfg s = { cfg | scripts = SA.insert s cfg.scripts }
                remsc cfg s = { cfg | scripts = SA.remove s cfg.scripts }
            in
            if SA.member script model.config.scripts then
                ( Debug.log "model" { model | config = remsc model.config script }
                , Cmd.none
                )
            else
                ( Debug.log "model" { model | config = addsc model.config script }
                , Cmd.none
                )
        ScriptOption key value ->
            let addso cfg k v = { cfg | scriptOpts =
                    D.insert k v cfg.scriptOpts }
            in
            ( Debug.log "scriptopt" { model | config = addso
                model.config key value }
            , Cmd.none
            )

view : Model -> Browser.Document Msg
view model =
    let frag = Maybe.withDefault "" model.url.fragment in
    { title = "puppy.tf"
    , body =
        [ div [ class "sidebar" ] <| viewTabButtons frag
            [ "scripts"
            , "binds"
            , "blocks"
            , "crosshair"
            , "hitsound"
            , "hud"
            , "preview"
            ] ++
            [ div [ class "end" ] [ text "crumbtoo/puppy.tf" ]
            ]
        , div [ class "beside-bar" ]
            [ viewTab frag model
            ]
        ]
    }

viewTabButtons : String -> List String -> List (Html msg)
viewTabButtons ctab = List.map <| viewTabButton ctab

viewTabButton : String -> String -> Html msg
viewTabButton ctab tabid =
    div
    [ classList
        [ ("tab-button", True)
        -- OPTIMISATION: i kinda wanna go back to tabs having integer IDs
        , ("active", ctab == tabid)
        ]
    ]
    [ a [ href ("#" ++ tabid) ] [ text tabid ]
    ]

viewTab : String -> Model -> Html Msg
viewTab tabid model =
    case tabid of
        "scripts" ->
            TabScripts.tabHTML model.config.scripts model.config.scriptOpts
        "binds" ->
            text "binds go here"
        "blocks" ->
            text "this one will be hard.,"
        "preview" ->
            viewPreview model
        _ ->
            text "none lol"

viewPreview : Model -> Html msg
viewPreview model = 
    let viewScripts =
            SA.toList model.config.scripts
            |> List.map (\sc ->
                p
                [ style "background-color" "black"
                , style "white-space" "pre-line"
                ]
                [ b [] [text sc.name]
                , p [] [text <| sc.generate model.config.scriptOpts]
                ]
            )
            |> div []

        viewBinds =
            div []
            [ p
                [ style "background-color" "black"
                , style "white-space" "pre-line"
                ]
                [ b [] [text "binds"]
                , p []
                    [ text <| TabScripts.genBinds
                        model.config.scripts
                        model.config.scriptOpts
                    ]
                ]
            ]
    in
    div []
    [ viewScripts
    , viewBinds
    ]
