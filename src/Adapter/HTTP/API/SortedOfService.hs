module Adapter.HTTP.API.SortedOfService where

import ClassyPrelude
import Web.Scotty.Trans
import Network.HTTP.Types.Status
import Data.Aeson ()
import Adapter.HTTP.Common
import Domain.ImportService
import Domain.ImportEntity
import qualified Prelude as Prelude

routes :: ( ScottyError e, MonadIO m, SortedOfService m)
          => ScottyT e m ()
routes = do
        get "/api/news/sortedNews/:condition" $ do
                condition   :: Text   <-      param "condition" 
                getResult <- lift $ sortedNews condition
                Web.Scotty.Trans.json getResult
