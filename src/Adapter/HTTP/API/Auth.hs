module Adapter.HTTP.API.Auth where

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



routes :: ( ScottyError e, MonadIO m, Auth m )
          => ScottyT e m ()

routes = do
        get "/api/auth/:password/:login" $ do
                login   :: Text   <-      param "login" 
                password      :: Text   <-      param "password" 
                result <- lift $ findUsers password login
                case result of 
                    Left err -> do
                        print "Ошибка авторизации"
                        status status400
                    Right user -> do
                        sess <- lift $ newSession user
                        setSessionIdInCookie sess
                        print "Авторизация успешная"
                        status status200

        get "/api/auth/exit" $ do
                        setDefaultCookie
                        print "Exit"
                        status status200
                
