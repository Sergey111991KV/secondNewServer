module Adapter.PostgreSQL.TestHelpPostgres where

import ClassyPrelude
import Test.Hspec
import Data.Time 
import Database.PostgreSQL.Simple
import Adapter.PostgreSQL.Common
import Text.StringRandom
import qualified Prelude as Prelude

import Domain.ImportService
import Domain.ImportEntity 
import qualified Adapter.PostgreSQL.ImportPostgres as PG
import qualified Logging.ImportLogging as Log



instance Auth (ReaderT State IO ) where
        findUsers = PG.findUsers
        newSession = PG.newSession
        findUserBySession = PG.findUserBySession
      
instance Log.Log (ReaderT State IO ) where
  logIn log txt = do
    let logStCong = Log.LogConfig { logFile = "log-journal" , logLevelForFile = Log.Debug , logConsole = True } 
    liftIO $ Log.writeLogginHandler logStCong  log txt
      

instance CommonService (ReaderT State IO ) where
      create  =   PG.create
      editing =   PG.editing
      getAll  =   PG.getAll
      getOne  =   PG.getOne
      remove  =   PG.remove
      update  =   PG.update
       

instance SortedOfService (ReaderT State IO ) where
        sortedNews  =   PG.sortedNews

instance FilterService (ReaderT State IO ) where
        filterOfData       =   PG.filterOfData
        filterAuthor        =   PG.filterAuthor
        filterCategory      =   PG.filterCategory
        filterTeg          =   PG.filterTeg
        filterOneOfTegs          = PG.filterOneOfTegs
        filterAllOfTegs          = PG.filterAllOfTegs
        filterName          =   PG.filterName
        filterContent      =   PG.filterContent




initDB :: IO ()
initDB = do
  conn <- connectPostgreSQL "postgresql://localhost"
  close conn
  withState testConf (const $ return ())

testConf :: Config
testConf =
  Config  { configUrl = " host='localhost' port=5432 dbname='hblog'"
          , configStripeCount = 2
          , configMaxOpenConnPerStripe = 5
          , configIdleConnTimeout = 10
          } 

runTestApp :: ReaderT State IO a -> IO a
runTestApp action = withPool testConf $ runReaderT action




randomUser :: IO User
randomUser = do
  let time = ( Prelude.read "2011-11-19 18:28:52.607875 UTC" ) :: UTCTime
  name <- stringRandomIO "[A-Za-z0]{16}"
  lastName <- stringRandomIO "[A-Za-z0]{16}"
  login <- stringRandomIO "[A-Za-z0]{16}"
  password <- stringRandomIO "[A-Za-z0]{16}"
  return $ User 26 name lastName login password "avatar" time True True  
   