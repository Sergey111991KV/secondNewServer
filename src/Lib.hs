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
import Logging.LogMonad
import Logging.Logging


type State = (PG.State)
newtype App a = App
  { unApp :: ReaderT State IO a
  } deriving (Applicative, Functor, Monad, MonadReader State, MonadIO, MonadThrow, Log)

run :: State -> App a -> IO a
run  state =  flip runReaderT state . unApp

instance MonadIO m => Log (ReaderT State m) where
        logIn log txt = do
                let confLog = Config.configLog Config.devConfig 
                liftIO $ writeLogginHandler confLog log txt
              

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

-- instance SearchIn App where
--                 searchInContent =  PG.searchInEntyty
--                 searchInEntyty  =  PG.searchInEntyty

withState :: Config.Config -> (Int -> State -> IO ()) -> IO ()
withState config action = do
        PG.withState (Config.configPG config) $ \pgState -> do
                let state = pgState -- тут можно накрутить state на state
                action (Config.configPort config) state

-- withLogging :: (LogConfig -> IO a) -> IO a
-- withLogging 


mainWithConfig :: Config.Config -> IO ()
mainWithConfig config = 
  withState config $ \port state -> do
    let runner = run  state
    HTTP.mainHTTP port runner

mainDev :: IO ()
mainDev = do
                -- let time = ( Prelude.read "2011-11-19 18:28:52.607875 UTC" )::UTCTime
                -- let pgArrayText = PGArray ["test 1 other photo", "test 1 other photo2"]
                -- let comment = Comment 5 "test comment4" time 1 1
                -- let draft = Draft 2 "test 2 draft" time 1 "test 2 main photo url" pgArrayText "TestDragtForFirstNews"
                -- let draft2 = Draft 3 "test 3 draft" time 1 "test 2 main photo url" pgArrayText "TestDragtForFirstNews"
                -- let teg = Teg 7 "Health"
                -- let teg2 = Teg 8 "India"
                -- let auth = Author 1 "TestAutor1" (User  2 "Daniel" "Abramov" "daniel11" "qwerty" "avatarDaniel"  time  True True)
                -- let cat3' = Category3 14 "Meditation in India" (Category2 7 "Meditation" (Category1 4 "Health"))
                -- let news =  News 
                --                 1  
                --                 time 
                --                 auth  
                --                 cat3' 
                --                 "News of Today" 
                --                 "url main Photo" 
                --                 pgArrayText 
                --                 "TodayNews" 
                --                 (PGArray [draft, draft2])
                --                 (PGArray [comment])
                --                 (PGArray [teg,teg2])
                -- let u =   "{authAdmin/":true,"lastName":"Abramojjv","dataCreate":"2011-11-19T18:28:52.607875Z","authPassword":"qwerty","nameU":"Daniel","authAuthor":true,"authLogin":"daniel1kk1","id_user":33,"avatar":"avatarDaniel"}'
                -- print (encode comment)
                -- print (encode teg)
                -- print (encode auth)
                -- print (encode news)
              

        mainWithConfig Config.devConfig
 