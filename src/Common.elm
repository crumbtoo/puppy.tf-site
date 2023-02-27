module Common exposing (..)

import Browser exposing (..)
import Browser.Navigation as Nav
import Url

type Msg = LinkClicked Browser.UrlRequest
         | UrlChanged Url.Url
         | ToggleScript String
         | ScriptOption String String
