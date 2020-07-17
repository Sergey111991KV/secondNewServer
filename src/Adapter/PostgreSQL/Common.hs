module Adapter.PostgreSQL.Common where

import Domain.ImportEntity 


import Data.Has
import Data.Pool
import Data.ByteString
import Control.Monad.Catch 
import Control.Monad.Reader
import Control.Monad.IO.Class

type PG r m = (Has State r, MonadReader r m, MonadIO m, MonadThrow m)

type State = Pool Connection

data Config = Config
  { configUrl :: ByteString
  , configStripeCount :: Int
  , configMaxOpenConnPerStripe :: Int
  , configIdleConnTimeout :: NominalDiffTime
  }

withPool :: Config -> (State -> IO a) -> IO a
withPool cfg action =
        bracket initPool cleanPool action
        where
          initPool = createPool openConn closeConn
                      (configStripeCount cfg)
                      (configIdleConnTimeout cfg)
                      (configMaxOpenConnPerStripe cfg)
          cleanPool = destroyAllResources
          openConn = connectPostgreSQL (configUrl cfg)
          closeConn = close

withState  ::  Config  -> ( State  ->  IO  a ) ->  IO  a
withState cfg action =
    withPool cfg $ \state -> do
        -- migrate state  можно добавлять дополнительные действия не меняя интерфейс главного действия withPool
        action state

withConn :: PG r m => (Connection -> IO a) -> m a
withConn action = do
  pool <- asks getter
  liftIO . withResource pool $ \conn -> action conn