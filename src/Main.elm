module Main exposing (main)
import Browser exposing (..)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Url
import Url.Builder as UB

main : Program () Model Msg
main = Browser.application
       { init = init
       , view = view
       , update = update
       , subscriptions = (\_ -> Sub.none)
       , onUrlChange = UrlChanged
       , onUrlRequest = LinkClicked
       }

type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }

type Msg = LinkClicked Browser.UrlRequest
         | UrlChanged Url.Url


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key = (Model key url, Cmd.none)

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

view : Model -> Browser.Document Msg
view model =
    let frag = Maybe.withDefault"" model.url.fragment in
    { title = "puppy.tf"
    , body =
        [ text "The current URL is: "
        , b [] [ text (Url.toString model.url) ]
        , div [ class "makecfg-container" ]
            [ div [ class "tabs-buttons" ] <| viewTabButtons frag ["scripts", "binds", "blocks"]
            , div [ class "tab-content" ]
                [ viewTab (Maybe.withDefault "scripts" model.url.fragment)
                ]
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

viewTab : String -> Html msg
viewTab tabid =
    case tabid of
        "scripts" ->
            text "this is the scripts tab :3"
        "binds" ->
            text "binds go here"
        "blocks" ->
            text "this one will be hard.,"
        _ ->
            text "none lol"


