module Adapter.HTTP.Main where


import ClassyPrelude
import Web.Scotty.Trans
import Network.HTTP.Types.Status
import qualified Adapter.HTTP.API.CommonService as ComServ
import qualified Adapter.HTTP.API.Auth as  AuthReppo
import qualified Domain.ImportService as Service
import qualified Domain.ImportEntity as Entity


import Network.Wai
-- import Network.Wai.Middleware.Gzip

mainHTTP :: (MonadIO m, Service.Auth m , Service.CommonService m) => Int -> (m Response -> IO Response) -> IO ()
mainHTTP port runner =
  scottyT port runner routes

routes :: (MonadIO m, Service.Auth m , Service.CommonService m) => ScottyT LText m ()
routes = do
--   middleware $ gzip $ def { gzipFiles = GzipCompress }
    AuthReppo.routes
    ComServ.routes


    defaultHandler $ \e -> do
        status status500
        json ("InternalServerError" :: Text)