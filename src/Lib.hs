module Lib 
    ( mainDev
        ) where

import ClassyPrelude
import Domain.ImportService
import Domain.ImportEntity 

import qualified Adapter.PostgreSQL.ImportPostgres as PG
import qualified Adapter.HTTP.Main as HTTP
import qualified Config as Config

import Control.Monad.Catch (MonadThrow, MonadCatch)
import qualified Prelude as Prelude 
import Database.PostgreSQL.Simple.Types
import Data.Time.LocalTime
import System.IO.Unsafe
import qualified Data.Attoparsec.ByteString.Char8 as A
import Domain.Parse.ParsePostgresTypes as TT
import qualified Text.Parsec as Parsec
import qualified ClassyPrelude as ClassyPrelude
import Logging



type State = (PG.State)
newtype App a = App
  { unApp :: ReaderT State IO a
  } deriving (Applicative, Functor, Monad, MonadReader State, MonadIO, MonadThrow)

run :: State -> App a -> IO a
run  state =  flip runReaderT state . unApp

instance CommonService App where
      create  =   PG.create
      editing =   PG.editing
      getAll  =   PG.getAll
      getOne  =   PG.getOne
      remove  =   PG.remove
      updeit  =   PG.updeit

instance Auth App where
        findUsers                   = PG.findUsers
        newSession                  = PG.newSession   
        findUserBySession           = PG.findUserBySession   

       

instance SortedOfService App where
        sortedNews  =   PG.sortedNews

instance FilterService App where
        filterOfData       =   PG.filterOfData
        filterAuthor        =   PG.filterAuthor
        filterCategory      =   PG.filterCategory
        filterTeg          =   PG.filterTeg
        filterOneOfTegs          = PG.filterOneOfTegs
        filterAllOfTegs          = PG.filterAllOfTegs
        filterName          =   PG.filterName
        filterContent      =   PG.filterContent

instance SearchIn App where
                searchInContent =  PG.searchInEntyty
                searchInEntyty  =  PG.searchInEntyty

withState :: Config.Config -> (Int -> State -> IO ()) -> IO ()
withState config action = do
        PG.withState (Config.configPG config) $ \pgState -> do
                let state = pgState -- тут можно накрутить state на state
                action (Config.configPort config) state

-- withLogging :: (LogConfig -> IO a) -> IO a



mainWithConfig :: Config.Config -> IO ()
mainWithConfig config = 
  withState config $ \port state -> do
    let runner = run  state
    HTTP.mainHTTP port runner

mainDev :: IO ()
mainDev = do
        mainWithConfig Config.devConfig
 