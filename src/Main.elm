module Main exposing (main)

import Browser exposing (..)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Url
import Url.Builder as UB
import Set exposing (..)
import Common exposing (..)

import TabScripts as TabScripts
import Tf2 exposing (Config)

type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , config : Tf2.Config
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


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key = (Model key url <| Tf2.Config empty, Cmd.none)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString <| Debug.log "a" url))

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        AddScript id -> -- Debug.todo "a"
            let addsc cfg s = { cfg | scripts = insert s cfg.scripts }
                remsc cfg s = { cfg | scripts = remove s cfg.scripts }
            in
            if Set.member id model.config.scripts then
                ( Debug.log "model" { model | config = remsc model.config id }
                , Cmd.none
                )
            else
                ( Debug.log "model" { model | config = addsc model.config id }
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
        , ("active", ctab == tabid) -- OPTIMISATION: i kinda wanna go back to tabs having integer IDs
        ]
    ]
    [ a [ href ("#" ++ tabid) ] [ text tabid ]
    ]

viewTab : String -> Model -> Html Msg
viewTab tabid model =
    case tabid of
        "scripts" ->
            TabScripts.tabHTML model.config.scripts
        "binds" ->
            text "binds go here"
        "blocks" ->
            text "this one will be hard.,"
        _ ->
            text "none lol"


