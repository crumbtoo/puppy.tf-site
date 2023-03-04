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
import Binds exposing (..)
import Dict as D

import TabScripts as TabScripts
import TabBinds as TabBinds

type alias Model =
    { key : Nav.Key
    , url : Url.Url
    -- unvalidated binds; not yet added to config.binds
    , userBinds : List (Int, TF2Key, String)
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

-- why does the stl have unzip but not zip lmao
zip : List a -> List b -> List (a, b)
zip la lb = List.map2 Tuple.pair la lb

-- no [0..x] notation :(
index : List a -> List (Int, a)
index ls =
    let rzip a b = zip b a in
    rzip ls <| List.range 0 <| List.length ls

flattenPP : List (a, (b, c)) -> List (a, b, c)
flattenPP = List.map (\ (a,(b,c)) -> (a,b,c))

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
    ( Model key url (D.toList Binds.defaultBinds |> index |> flattenPP)
        <| Common.Config
            (SA.empty Common.compareScript)
            D.empty
            Binds.defaultBinds
            (DA.empty Common.compareClass)
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
        UpdateUserBind i k v ->
            -- would've been cleaer if i could use multiple function
            -- declarations to pattern match..
            let replaceI : Int -> List a -> a -> List a
                replaceI ind ls l =
                    case ls of
                        [] ->
                            []
                        (x::xs) ->
                            case ind of
                                0 -> l :: xs
                                _ -> x :: (replaceI (ind - 1) xs l)
            in
            ( { model | userBinds = replaceI i model.userBinds
                (Debug.log "UpdateUserBind" (i,k,v)) }
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view model =
    let frag = Maybe.withDefault "" model.url.fragment in
    { title = "puppy.tf"
    , body =
        [ div [ class "sidebar" ] <| viewTabButtons frag
            -- TODO: misc tab. like uploading a spray etc
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
    let h tname content =
            div
            [ hidden <| tname /= tabid -- hide if not tname
            , class "tab-container" ]
            [ content ]
    in
    -- TODO: add error message floating behind tab content,
    -- making it visible when no content is displayed over
    -- it.
    div []
    [ h "scripts" <| TabScripts.viewTab model.config.scripts model.config.scriptOpts
    , h "binds"   <| TabBinds.viewTab model.userBinds
    , h "preview" <| viewPreview model
    ]

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
                    [ text <| TabBinds.genBinds
                        model.config.binds
                        model.config.scripts
                    ]
                ]
            ]
    in
    div []
    [ viewScripts
    , viewBinds
    ]

