module Lib
  ( mainDev
  ) where

import ClassyPrelude
import Domain.ImportEntity
import Domain.ImportService

import qualified Adapter.HTTP.Main as HTTP
import qualified Adapter.PostgreSQL.ImportPostgres as PG
import qualified Config

import Control.Monad.Catch (MonadCatch, MonadThrow)
import qualified Data.Attoparsec.ByteString.Char8 as A
import Data.Has
import Data.Time.LocalTime
import Database.PostgreSQL.Simple.Types
import Domain.Parse.ParsePostgresTypes as TT
import qualified Logging.ImportLogging as Log
import qualified Prelude
import qualified Text.Parsec as Parsec

type State = (PG.State, TVar Log.State)

newtype App a =
  App
    { unApp :: ReaderT State IO a
    }
  deriving ( Applicative
           , Functor
           , Monad
           , MonadReader State
           , MonadIO
           , MonadThrow
           , Log.Log
           )

run :: State -> App a -> IO a
run state = flip runReaderT state . unApp

instance MonadIO m => Log.Log (ReaderT State m) where
  logIn log txt = do
    (st, st2) <- ask
    logSt <- readTVarIO st2
    liftIO $ Log.writeLogginHandler (Log.logStCong logSt) log txt

instance CommonService App where
  create = PG.create
  editing = PG.editing
  getAll = PG.getAll
  getOne = PG.getOne
  remove = PG.remove
  update = PG.update

instance Auth App where
  findUsers = PG.findUsers
  newSession = PG.newSession
  findUserBySession = PG.findUserBySession

instance SortedOfService App where
  sortedNews = PG.sortedNews

instance FilterService App where
  filterOfData = PG.filterOfData
  filterAuthor = PG.filterAuthor
  filterCategory = PG.filterCategory
  filterTeg = PG.filterTeg
  filterOneOfTegs = PG.filterOneOfTegs
  filterAllOfTegs = PG.filterAllOfTegs
  filterName = PG.filterName
  filterContent = PG.filterContent

withState :: Config.Config -> (Int -> State -> IO ()) -> IO ()
withState config action = do
  PG.withState (Config.configPG config) $ \pgState -> do
    logState <- newTVarIO $ Config.configLog config
    let state = (pgState, logState)
    action (Config.configPort config) state

mainWithConfig :: Config.Config -> IO ()
mainWithConfig config =
  withState config $ \port state -> do
    let runner = run state
    HTTP.mainHTTP port runner

mainDev :: IO ()
mainDev = do
  mainWithConfig Config.devConfig
