module Adapter.HTTP.API.Auth where

import Adapter.HTTP.Common
import ClassyPrelude
import Data.Aeson ()
import Domain.ImportEntity
import Domain.ImportService
import Network.HTTP.Types.Status
import Web.Scotty.Trans


routes :: (ScottyError e, MonadIO m, Auth m) => ScottyT e m ()
routes = do
  get "/api/auth/:password/:login" $ do
    login :: Text <- param "login"
    password :: Text <- param "password"
    result <- lift $ findUsers password login
    case result of
      Left err
       -> do
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
