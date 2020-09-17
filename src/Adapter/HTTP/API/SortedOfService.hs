module Adapter.HTTP.API.SortedOfService where

import Adapter.HTTP.Common
import ClassyPrelude
import Data.Aeson ()
import Domain.ImportEntity
import Domain.ImportService
import Network.HTTP.Types.Status
import Web.Scotty.Trans

routes :: (ScottyError e, MonadIO m, SortedOfService m) => ScottyT e m ()
routes = do
  get "/api/news/sortedNews/:condition" $ do
    condition :: Text <- param "condition"
    getResult <- lift $ sortedNews condition
    Web.Scotty.Trans.json getResult
