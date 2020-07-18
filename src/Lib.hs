module Lib 
    ( someFunc
        ) where

import Domain.ImportService
import Domain.ImportEntity 
import qualified Adapter.PostgreSQL.ImportPostgres as PG
import Control.Monad.Catch (MonadThrow, MonadCatch)
import ClassyPrelude
import qualified Config as Config

type State = (PG.State)
newtype App a = App
  { unApp :: ReaderT State IO a
  } deriving (Applicative, Functor, Monad, MonadReader State, MonadIO, MonadThrow)

run :: State -> App a -> IO a
run  state =  flip runReaderT state . unApp

instance CommonService App where
    --   create  =   PG.create
    --   editing =   PG.editing
    --   getAll  =   PG.getAll
      getOne  =   PG.getOne
    --   remove  =   PG.remove



someFunc :: IO ()
someFunc = 
    withState Config.devConfig $ \pgState -> do 
        run pgState action
        
       

withState :: Config.Config -> (State -> IO ()) -> IO ()
withState config action =
    PG.withState (Config.configPG config) $ \pgState -> do
          let state = pgState
          action state


action :: App ()
action = do
    -- user <-  getOne True "user" 1
    -- print user
    tag <- getOne True  "teg" 1
    print tag