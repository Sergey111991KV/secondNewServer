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
import qualified Prelude as Prelude -------------------------
import Database.PostgreSQL.Simple.Types
import Data.Time.LocalTime
import System.IO.Unsafe
import qualified Data.Attoparsec.ByteString.Char8 as A
import Domain.Parse.ParsePostgresTypes as TT
import qualified Text.Parsec as Parsec
import qualified ClassyPrelude as ClassyPrelude



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
        filterTegs          = PG.filterTegs
        -- filterName          =   PG.filterName
        -- filterContent      =   PG.filterContent



withState :: Config.Config -> (Int -> State -> IO ()) -> IO ()
withState config action = do
    PG.withState (Config.configPG config) $ \pgState -> do
          let state = pgState -- тут можно накрутить state на state
          action (Config.configPort config) state





mainWithConfig :: Config.Config -> IO ()
mainWithConfig config = 
  withState config $ \port state -> do
    let runner = run  state
    HTTP.mainHTTP port runner

mainDev :: IO ()
mainDev = mainWithConfig Config.devConfig


        

-- action :: App ()
-- action = do
--     -- let t  = getZonedTime
--     let time = ( Prelude.read "2011-11-19 18:28:52.607875 UTC" )::UTCTime
--     let time' = "2011-11-19 22:28:52.607875+04" :: String

--         -- unsafePerformIO getZonedTime
--         -- unsafePerformIO getCurrentTime
--         -- unsafePerformIO getZonedTime
--         -- (Prelude.read "2014-04-04 20:00:00-07") :: ZonedTime
--     let pgArrayText = PGArray ["test 1 other photo", "test 1 other photo2"]
--     let auth = EntAuthor (Author 1 "TestAutor1" (User  2 "Daniel" "Abramov" "daniel11" "qwerty" "avatarDaniel"  time  True True))
--     let auth2 = EntAuthor (Author 6 "DaniTEST2!!!!" (User  2 "Daniel" "Abramov" "daniel11" "qwerty" "avatarDaniel"  time  True True))
--     let auth' = Author 5 "DaniTEST!!!!" (User  2 "Daniel" "Abramov" "daniel11" "qwerty" "avatarDaniel"  time  True True)
--     -- createAuth <- create True auth
--     -- print  createAuth
--     let us = EntUser (User 33 "TestUser" "TestLastName" "dd" "qwerty" "avatar" time True True)  
--     let teg = EntTeg (Teg 6 "testTeg6")
--     let teg' = Teg 1 "testTeg!!!!!!"
--     let teg'' = Teg 2 "History"
--     let cat1 = EntCategory (CatCategory1 (Category1 4 "Art"))
--     let cat2 = EntCategory (CatCategory2 (Category2 7 "Theatre" (Category1 4 "Art")))
--     let cat3 = EntCategory (CatCategory3 (Category3 12 "Prestige" (Category2 6 "Theatre" (Category1 4 "Art"))))
--     let cat3' = Category3 12 "Big Theatre of Moskow" (Category2 7 "Theatre" (Category1 4 "Art"))
--     let cat3'' = Category3 7 "Big Theatre of Moskow" (Category2 7 "Theatre" (Category1 4 "Art"))
--     let cat34 = Category3 7 "Big Theatre of Moskow" (Category2 7 "Theatre" (Category1 4 "Art"))
--     let comment = (EntComment  (Comment 5 "test comment4" time 1 1))
--     let comment' =  PGArray [Comment 2 "test comment1" time 1 1] :: PGArray Comment
    
--     let draft = (EntDraft    (Draft 2 "test 2 draft" time 1 "test 2 main photo url" pgArrayText "TestDragtForFirstNews")) 
--     let draft' = Draft 2 "test 2 draft" time 1 "test 1 main photo url" pgArrayText "TestDragtForFirstNews"
--     let draft'' = (Draft 2 "test 2 draft" time 2 "test 2 main photo url" pgArrayText "TestDragtForFirstNews")
--     let news = ( EntNews (News 
--                                 1  
--                                 time 
--                                 auth'  
--                                 cat3' 
--                                 "News of Today" 
--                                 "url main Photo" 
--                                 pgArrayText 
--                                 "TodayNews" 
--                                 (PGArray [draft'])
--                                 comment'
--                                 (PGArray [teg'])
--                                 ))
--     -- let news1 = ( EntNews (News 
--     --                             4  
--     --                             time 
--     --                             auth'  
--     --                             cat3'' 
--     --                             "News of Now" 
--     --                             "url main Photo" 
--     --                             pgArrayText 
--     --                             "TodayNews" 
--     --                             (PGArray [draft''])
--     --                             comment'
--     --                             (PGArray [teg'])
--     --                             ))
--     -- let news2 = ( EntNews (News 
--     --                             6  
--     --                             time 
--     --                             auth'  
--     --                             cat34 
--     --                             "News of Germany" 
--     --                             "url main Photo" 
--     --                             pgArrayText 
--     --                             "TodayNews" 
--     --                             (PGArray [draft'])
--     --                             comment'
--     --                             (PGArray [teg''])
--     --                             ))
    
--     -- testTeg <- PG.testArrayTeg
--     -- print testTeg
--     -- testComment <- PG.testArrayComment
--     -- print testComment
--     -- testDraft <- PG.testArrayDraft
--     -- print testDraft
    
    
--     -- user <-  getOne True "user" 1
--     -- print user
--     -- tag <- getOne True  "tag" 5
--     -- print tag
--     -- draft <- getOne True  "draft" 1 
--     -- print draft
--     -- comment <- getOne True   "comment" 3
--     -- print comment
--     -- author <- getOne True  "author" 1 
--     -- print author
--     -- category1 <- getOne True  "category1" 1 
--     -- print category1
--     -- category2 <- getOne True  "category2" 1 
--     -- print category2
--     -- category3 <- getOne True  "category3" 1 
--     -- print category3
--     -- news <- getOne True  "news" 1
--     -- print news

--     -- createTeg <- create True teg
--     -- print createTeg
--     -- createCat1 <- create True cat1
--     -- print createCat1
--     -- createCat2 <- create True cat2
--     -- print createCat2
--     -- createCat3 <- create True cat3
--     -- print createCat3
--     -- createComm <- create True comment
--     -- print createComm
--     -- createDraft <- create True draft
--     -- print createDraft
--     -- createAuthor <- create True auth
--     -- print createAuthor
--     -- createAuthor <- create True auth2
--     -- print createAuthor
--     -- createUser <- create True us 
--     -- print createUser
--     -- createNews <- create True news
--     -- createNews1 <- create True news1
--     -- createNews2 <- create True news2
--     -- print createNews


--     -- news <- getAll True  "news" 
--     -- print news
--     -- author <- getAll True  "authors" 
--     -- print author
--     -- user <-  getAll True "users" 
--     -- print user
--     -- tag <- getAll True  "tags" 
--     -- print tag
--     -- category1 <- getAll True  "categorys1" 
--     -- print category1
--     -- category2 <- getAll True  "categorys2" 
--     -- print category2
--     -- category3 <- getAll True  "categorys3" 
--     -- print category3
   
--     -- draft <- getAll True  "drafts" 
--     -- print draft
--     -- comment <- getAll True   "comments" 
--     -- print comment

--     -- removeTeg <- remove True  "tag" 1 
--     -- print removeTeg
--     -- removeCat1 <- remove True  "category1" 4
--     -- print removeCat1
--     -- removeCat2 <- remove True  "category2" 7
--     -- print removeCat2
--     -- removeCat3 <- remove True  "category3" 13
--     -- print removeCat3
--     -- removeComm <- remove True "comment" 1 
--     -- print removeComm
--     -- removeDraft <- remove True "draft" 1 
--     -- print removeDraft
--     -- removeUser <- remove True "user" 33
--     -- print removeUser
--     -- removeNews <- remove True  "news" 1
--     -- print removeNews
    
    

--     -- editingTeg <- editing True teg
--     -- print editingTeg
--     -- editingCat1 <- editing True cat1
--     -- print editingCat1
--     -- editingCat2 <- editing True cat2
--     -- print editingCat2
--     -- editingCat3 <- editing True cat3
--     -- print editingCat3
--     -- editingAuthor <- editing True auth
--     -- print editingAuthor
--     -- editingComm <- editing True comment
--     -- print editingComm
--     -- editingDraft <- editing True draft
--     -- print editingDraft
--     -- editingUser <- editing True us 
--     -- print editingUser
--     -- editingNews <- editing True news
--     -- print editingNews

--     -- sorteD <- sortedNews "date"
--     -- print sorteD
--     -- sorteA <- sortedNews "author"
--     -- print sorteA
--     -- sorteC <- sortedNews "category"
--     -- print sorteC
--     -- sorteP <- sortedNews "photo"
--     -- print sorteP

    
  
--     -- filA <- filterAuthor  "DaniTEST!!!!"
--     -- print filA
--     -- filA <- filterCategory  13
--     -- print filA


--     oneTegNews <- filterTeg 1
--     print oneTegNews
--     -- filD <- filterOfData   time' "<"
--     -- print    filD 
    
--     -- filterName          =   PG.filterName
--     -- filterContent      =   PG.filterContent





--     print "end"
  




