module Adapter.HTTP.Main where


import ClassyPrelude
import Web.Scotty.Trans
import Network.HTTP.Types.Status
import qualified Adapter.HTTP.API.CommonService as ComServ


import Network.Wai
-- import Network.Wai.Middleware.Gzip

mainHTTP :: MonadIO m => Int -> (m Response -> IO Response) -> IO ()
mainHTTP port runner =
  scottyT port runner routes

routes :: MonadIO m => ScottyT LText m ()
routes = do
--   middleware $ gzip $ def { gzipFiles = GzipCompress }

  ComServ.routes

  defaultHandler $ \e -> do
    status status500
    json ("InternalServerError" :: Text)