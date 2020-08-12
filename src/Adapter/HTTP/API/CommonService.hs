module Adapter.HTTP.API.CommonService where

import ClassyPrelude
import Web.Scotty.Trans
import Network.HTTP.Types.Status
import Data.Aeson ()
import Adapter.HTTP.Common
import Domain.ImportService
import Domain.ImportEntity
import qualified Prelude as Prelude

-- create  :: Bool -> Entity  -> m (Either Error ())
-- editing :: Bool -> Entity -> m (Either Error ())
-- getAll  :: Bool -> Text -> m (Either Error [Entity])
-- getOne  :: Bool -> Text -> Int ->  m (Either Error  Entity)
-- remove  :: Bool -> Text -> Int ->  m (Either Error ())




routes :: ( ScottyError e, MonadIO m, CommonService m)
          => ScottyT e m ()
routes = do
        get "/api/getOne/:entity/:idE" $ do
                authResult <- getCookie "sId"
                case authResult of
                    Nothing -> do
                            status status400
                            Web.Scotty.Trans.json ("not verification" :: Text)
                    Just sess -> do
                        print sess
                        entity   :: Text   <-      param "entity" 
                        idE      :: Text   <-      param "idE" 
                        getResult <- lift $ getOne (SessionId sess) entity (Prelude.read (ClassyPrelude.unpack idE) :: Int)
                        case getResult of
                            Left err -> do
                                    status status400
                                    print "error"
                            Right (EntAuthor author) -> do
                                    Web.Scotty.Trans.json author
                           



        get "/api/getAll/:entity/" $ do
                authResult <- getCookie "sId"
                case authResult of
                    Nothing -> do
                            status status400
                            Web.Scotty.Trans.json ("not verification" :: Text)
                    Just sess -> do
                        print sess
                        entity   :: Text   <-      param "entity" 
                        getResult <- lift $ getAll (SessionId sess) entity
                        case getResult of
                            Left err -> do
                                    status status400
                                    print "error"
                            Right ent -> do
                                case entity of
                                    "authors" -> Web.Scotty.Trans.json ((convertFromEntityArray ent) :: [Author])
             