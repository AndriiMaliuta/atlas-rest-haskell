{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import Data.Foldable
import Data.String
import Data.Convertible
import Data.List
import Network.HTTP.Simple
import Data.Aeson
import Text.HTML.TagSoup
import Text.StringLike(StringLike)
import qualified Data.ByteString.Lazy.Char8 as L8
import qualified Data.ByteString.Char8 as S8
import qualified Data.Yaml             as Yaml


data CreatePageReq = CreatePageReq String String

-- main
main :: IO ()
main = do
   let bodyData = "{\"type\":\"page\", \"title\":\"new page\", \"space\": {\"key\":\"BBB\"},\"body\":{\"storage\":{\"value\":\"<p>This is <br/> page</p>\", \"representation\": \"storage\"}}}"
   request' <- parseRequest "POST http://localhost:7202/rest/api/content"
   let request
              = setRequestMethod "POST"
              $ setRequestPath "/rest/api/content"
              $ setRequestBodyLBS bodyData
              $ setRequestSecure False
              $ setRequestPort 7202
              $ request'

   response <- httpJSON request
   S8.putStrLn $ Yaml.encode (getResponseBody response :: Value)
   print "DOne!"


postHttpSimple = do
    let bodyData = "{\"type\":\"page\", \"title\":\"new page\", \"space\": {\"key\":\"BBB\"},\"body\":{\"storage\":{\"value\":\"<p>This is <br/> page</p>\", \"representation\": \"storage\"}}}"
    request' <- parseRequest "POST http://localhost:7202/rest/api/content"
    let request
              = setRequestMethod "POST"
              $ setRequestPath "/rest/api/content"
              $ setRequestBodyLBS bodyData
              $ setRequestSecure False
              $ setRequestPort 7202
              $ request'

    response <- httpJSON request
    S8.putStrLn $ Yaml.encode (getResponseBody response :: Value)
  --  resp <- httpLBS "http://localhost:7202/rest/api/content"


--postHttpDataBody = do
