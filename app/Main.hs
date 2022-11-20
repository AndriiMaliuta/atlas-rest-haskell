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

data Page = Page {
  id :: Integer,
  title :: String
} deriving (Show, Eq)

--data Space = Space String
--data Storage = Storage String String
--data Body = Body Storage
--data CreatePageReq = CreatePageReq String String Space Body
--instance ToJSON CreatePageReq where
--  toJSON (CreatePageReq ctype title space body) = object
--    [ "type" .= ctype,
--      "title" .= title,
--      "space" .= space,
--      "body" .= body
--    ]
--
--toCreate :: CreatePageReq
--toCreate = CreatePageReq "page" "hask page 1" Space "BBB" Body Storage "" "" ""

maybePage :: L8.ByteString -> Maybe Page
maybePage a = decode a

-- main
main :: IO ()
main = do
  let request = setRequestHeader "Authorization" ["Basic YWRtaW46YWRtaW4K=="]
                  $ "GET http://localhost:7202/rest/api/content/917526"
  response <- httpLBS request
  let respBody = (getResponseBody response) :: L8.ByteString
  let bodyDecoded = maybePage respBody
  print bodyDecoded

  --  let request = setRequestBodyJSON toCreate $ "POST http://localhost:7202/rest/api/content"
--  response <- httpJSON request
--
--  putStrLn $ "The status code was: " ++
--             show (getResponseStatusCode response)
--  print $ getResponseHeader "Content-Type" response
--  S8.putStrLn $ Yaml.encode (getResponseBody response :: Value)


postHttpSimple = do
    let bodyData = "{ \"type\" :\"page\", \"title\": \"new page\", \"space\": { \"key\": \"BBB\"}, \"body\": { \"storage\": { \"value\": \"<p>This is <br/> page</p>\", \"representation\": \"storage\"}}}"
--    let bodyData = "{"type":"page","title":"new page",
--                    "space":{"key":"TST"},"body":{"storage":{"value":"<p>This is <br/> a new page</p>","representation":
--                    "storage"}}}"
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
