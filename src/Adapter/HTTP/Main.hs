module Adapter.HTTP.Main where

import Adapter.HTTP.Common
import ClassyPrelude
import Network.HTTP.Types.Status
import Web.Cookie
import Web.Scotty.Trans

import qualified Adapter.HTTP.API.Auth as AuthReppo
import qualified Adapter.HTTP.API.CommonService as ComServ
import qualified Adapter.HTTP.API.FilterService as FiltServ
import qualified Adapter.HTTP.API.SortedOfService as SortServ

import qualified Domain.ImportEntity as Entity
import qualified Domain.ImportService as Service

import Network.Wai
import Network.Wai.Handler.Warp

-- import Network.Wai.Middleware.Gzip
app ::
     ( MonadIO m
     , Service.Auth m
     , Service.CommonService m
     , Service.FilterService m
     , Service.SortedOfService m
     )
  => (m Response -> IO Response)
  -> IO Application
app runner = scottyAppT runner routes

mainHTTP ::
     ( MonadIO m
     , Service.Auth m
     , Service.CommonService m
     , Service.FilterService m
     , Service.SortedOfService m
     )
  => Int
  -> (m Response -> IO Response)
  -> IO ()
mainHTTP port runner = app runner >>= run port

routes ::
     ( MonadIO m
     , Service.Auth m
     , Service.CommonService m
     , Service.FilterService m
     , Service.SortedOfService m
     )
  => ScottyT LText m ()
routes
--   middleware $ gzip $ def { gzipFiles = GzipCompress }
 = do
  AuthReppo.routes
  ComServ.routes
  FiltServ.routes
  SortServ.routes
  defaultHandler $ \e -> do
    status status500
    json ("InternalServerError" :: Text)
