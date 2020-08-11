module Adapter.HTTP.API.CommonService where

import ClassyPrelude
import Web.Scotty.Trans
import Network.HTTP.Types.Status
import Data.Aeson ()
import Adapter.HTTP.Common
import Domain.ImportService
import Domain.ImportEntity

-- create  :: Bool -> Entity  -> m (Either Error ())
-- editing :: Bool -> Entity -> m (Either Error ())
-- getAll  :: Bool -> Text -> m (Either Error [Entity])
-- getOne  :: Bool -> Text -> Int ->  m (Either Error  Entity)
-- remove  :: Bool -> Text -> Int ->  m (Either Error ())



routes :: ( ScottyError e, MonadIO m)
          => ScottyT e m ()
routes = do
        get "/api/getOne/:entity/:idE" $ do
                
                entity   :: Text   <-      param "entity" 
                idE      :: Text   <-      param "idE" 
                case entity of
                        "authors"  -> do
                            print "setSessionIdInCookie"
                            status status200


             