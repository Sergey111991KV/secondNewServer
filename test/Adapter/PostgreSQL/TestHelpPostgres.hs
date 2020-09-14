module Adapter.PostgreSQL.TestHelpPostgres where

import ClassyPrelude 
import Test.Hspec
import Data.Time 
import Database.PostgreSQL.Simple
import Adapter.PostgreSQL.Common
import Text.StringRandom
import qualified Prelude as Prelude
import System.Random
import Database.PostgreSQL.Simple.Types 

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
  idU <- getStdRandom (randomR (1,1000000))
  return $ User idU name lastName login password "avatar" time True True  

randomAuthor :: IO Author
randomAuthor = do
  -- idA      <- getStdRandom (randomR (1,1000000))
  let time = ( Prelude.read "2011-11-19 18:28:52.607875 UTC" ) :: UTCTime
  let descrip = "test"
  let us = (User  2 "Daniel" "Abramov" "daniel11" "qwerty" "avatarDaniel"  time  True True)
  return $ Author 2 descrip us

randomCategory1 :: IO Category1
randomCategory1 = do
    idCat1      <- getStdRandom (randomR (1,1000000))
    let name = "test"
    return $ Category1 idCat1  name 

randomCategory2 :: IO Category2
randomCategory2 = do
        let cat1 = Category1 4 "Health"
        idCat2      <- getStdRandom (randomR (1,1000000))
        let name = "test"
        return $ Category2 idCat2  name cat1
  
randomCategory3 :: IO Category3
randomCategory3 = do
  let cat2 =  (Category2 7 "Meditation" (Category1 4 "Health"))
  idCat3      <- getStdRandom (randomR (1,1000000))
  let name = "test"
  return $ Category3 idCat3 name cat2
  


randomComment :: IO Comment
randomComment = do
  idcom <- getStdRandom (randomR (1,1000000))
  let text = "test"
  let time = ( Prelude.read "2011-11-19 18:28:52.607875 UTC" ) :: UTCTime
  return $ Comment idcom text time 2 5



randomDraft :: IO Draft
randomDraft = do
  iddraft <- getStdRandom (randomR (1,1000000))
  let text = "test"
  let time = ( Prelude.read "2011-11-19 18:28:52.607875 UTC" ) :: UTCTime
  let mainphoto = "test"
  let pgArrayText = PGArray ["test 1 other photo", "test 1 other photo2"]
  let short = "test"
  return $ Draft iddraft text time 2 mainphoto pgArrayText short  


  
randomNews :: IO News
randomNews = do
  idnews <- getStdRandom (randomR (1,1000000))
  let time = ( Prelude.read "2011-11-19 18:28:52.607875 UTC" ) :: UTCTime
  let auth = Author 1 "TestAutor1" (User  2 "Daniel" "Abramov" "daniel11" "qwerty" "avatarDaniel"  time  True True)
  let category = Category3 13 "Meditation in India" (Category2 7 "Meditation" (Category1 4 "Health"))
  text <- stringRandomIO "[A-Za-z0]{16}"
  mainPhoto <- stringRandomIO "[A-Za-z0]{16}"
  let pgArrayText = PGArray ["test 1 other photo", "test 1 other photo2"]
  shortName <- stringRandomIO "[A-Za-z0]{16}"
  let pgArrayDraft = PGArray [Draft 2 "test 2 draft" time 1 "test 2 main photo url" pgArrayText "TestDragtForFirstNews"]
  let pgArrayComment = PGArray [Comment 5 "test comment4" time 1 1]
  let pgArrayTeg = PGArray [ Teg 7 "Health"]
  return $ News idnews time auth category text mainPhoto pgArrayText shortName pgArrayDraft pgArrayComment pgArrayTeg
 
randomTeg :: IO Teg
randomTeg = do
  idt   <- getStdRandom (randomR (1,1000000))
  let namet = "test"
  
  return $ Teg idt namet
   