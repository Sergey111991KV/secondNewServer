module Lib 
    ( someFunc
        ) where

import Domain.ImportService
import Domain.ImportEntity 
import qualified Adapter.PostgreSQL.ImportPostgres as PG
import Control.Monad.Catch (MonadThrow, MonadCatch)
import ClassyPrelude
import qualified Prelude as Prelude -------------------------
import qualified Config as Config
import Database.PostgreSQL.Simple.Types

type State = (PG.State)
newtype App a = App
  { unApp :: ReaderT State IO a
  } deriving (Applicative, Functor, Monad, MonadReader State, MonadIO, MonadThrow)

run :: State -> App a -> IO a
run  state =  flip runReaderT state . unApp

instance CommonService App where
      create  =   PG.create
      editing =   PG.editing
    --   getAll  =   PG.getAll
      getOne  =   PG.getOne
      remove  =   PG.remove



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
    -- tag <- getOne True  "tag" 1 
    -- print tag
    -- draft <- getOne True  "draft" 1 
    -- print draft
    -- comment <- getOne True   "comment" 1 
    -- print comment
    -- author <- getOne True  "author" 1 
    -- print author
    -- category1 <- getOne True  "category1" 1 
    -- print category1
    -- category2 <- getOne True  "category2" 1 
    -- print category2
    -- category3 <- getOne True  "category3" 1 
    -- print category3
    -- news <- getOne True  "news" 1 
    -- print news
    let time = (Prelude.read "2011-11-19 18:28:52.607875 UTC") :: UTCTime
    let pgArrayText = PGArray ["test 1 other photo", "test 1 other photo2"]
    let auth = EntAuthor (Author 5 "DaniTEST!!!!" (User  2 "Daniel" "Abramov" "daniel11" "qwerty" "avatarDaniel"  time  True True))
    let auth' = Author 5 "DaniTEST!!!!" (User  2 "Daniel" "Abramov" "daniel11" "qwerty" "avatarDaniel"  time  True True)
    -- createAuth <- create True auth
    -- print  createAuth
    let us = EntUser (User 33 "TestUser" "TestLastName" "dd" "qwerty" "avatar" time True True)  
    let teg = EntTeg (Teg 1 "testTeg!!!!!!")
    let teg' = Teg 1 "testTeg!!!!!!"
    let cat1 = EntCategory (CatCategory1 (Category1 4 "Art"))
    let cat2 = EntCategory (CatCategory2 (Category2 7 "Theatre" (Category1 4 "Art")))
    let cat3 = EntCategory (CatCategory3 (Category3 13 "Big Theatre of Moskow" (Category2 7 "Theatre" (Category1 4 "Art"))))
    let cat3' = Category3 13 "Big Theatre of Moskow" (Category2 7 "Theatre" (Category1 4 "Art"))
    let comment = (EntComment  (Comment 1 "test comment1" time 1 1))
    let comment' =  PGArray [Comment 1 "test comment1" time 1 1] :: PGArray Comment
    let draft = (EntDraft    (Draft 1 "test 1 draft" time 1 "test 1 main photo url" pgArrayText "TestDragtForFirstNews")) 
    let draft' = (Draft 1 "test 1 draft" time 1 "test 1 main photo url" pgArrayText "TestDragtForFirstNews")
    let news = ( EntNews (News 
                                2  
                                time 
                                auth'  
                                cat3' 
                                "News of Today" 
                                "url main Photo" 
                                pgArrayText 
                                "TodayNews" 
                                (PGArray [draft'])
                                comment'
                                (PGArray [teg'])
                                ))
   
    -- id_news               :: Int,
    -- data_create_news      :: UTCTime,
    -- authors               :: Author,
    -- category              :: Category3,
    -- text_news             :: Text,
    -- main_photo_url_news   :: Text,
    -- other_photo_url_news  :: PGArray Text,
    -- short_name_news       :: Text
    -- , drafts                :: PGArray Draft,
    -- comments              :: PGArray Comment,
    -- tegs                  :: PGArray Teg



    -- createTeg <- create True teg
    -- print createTeg
    -- createCat1 <- create True cat1
    -- print createCat1
    -- createCat2 <- create True cat2
    -- print createCat2
    -- createCat3 <- create True cat3
    -- print createCat3
    -- createComm <- create True comment
    -- print createComm
    -- createDraft <- create True draft
    -- print createDraft
    -- createDraft <- create True draft
    -- print createDraft
    -- createUser <- create True us 
    -- print createUser
    createNews <- create True news
    print createNews


    
    
   

    -- remTag <- remove True "tag" 1
    -- print remTag
    -- editTag <- editing True teg 
    -- print editTag
   





    -- SELECT news.id, news.data_create, author.id, author.description, user_blog.id_user, user_blog.name, user_blog.last_name, user_blog.login, user_blog.password, user_blog.avatar, user_blog.data_create, user_blog.admini, user_blog.author , category_3.id, category_3.description, category_2.id, category_2.description, category_1.id, category_1.description , news.description , news.main_photo_url , 
    -- ARRAY ( SELECT news.other_photo_url FROM news) , 
    -- news.short_name 
    -- , ARRAY(SELECT ROW (drafts.id , drafts.description , drafts.data_create , drafts.news_id , drafts.main_photo_url , drafts.other_photo_url , drafts.short_name  ) FROM drafts where drafts.news_id = news.id )
    -- , ARRAY(SELECT ROW (comments.id_comments, comments.text_comments , comments.data_create_comments , comments.news_id_comments , comments.users_id_comments) FROM comments where comments.news_id_comments = news.id ) 
    -- , ARRAY(SELECT ROW (tags.id, tags.name) FROM (news JOIN news_tags USING (id)) JOIN tags USING (id)) 
    -- FROM news , author , user_blog, category_3, category_2, category_1, drafts, comments, tags, news_tags where news.id = (?)
   
    --                                        \ FROM news , author , user_blog, category_3, category_2, category_1, drafts, comments, tags, news_tags  where news.id = (?)"




    --                                        "SELECT   news.id \
    --                                        \ , news.data_create \
    --                                        \ , author.id, author.description, user_blog.id_user, user_blog.name, user_blog.last_name, user_blog.login, user_blog.password, user_blog.avatar, user_blog.data_create, user_blog.admini, user_blog.author \
    --                                        \ , category_3.id, category_3.description, category_2.id, category_2.description, category_1.id, category_1.description \
    --                                        \ , news.description \
    --                                        \ , news.main_photo_url \
    --                                        \ , ARRAY (SELECT news.other_photo_url FROM news) \
    --                                        \ , news.short_name \
    --                                        \ , ARRAY(SELECT * FROM drafts where drafts.news_id = news.id ) \
    --                                        \ , ARRAY(SELECT * FROM comments where comment.news_id_comments = news.id ) \
    --                                        \ , ARRAY(SELECT tags.id, tags.name FROM (news JOIN news_tags USING (news.id)) JOIN tags USING (tags.id)) \
    --                                        \ FROM news , author , user_blog, category_3, category_2, category_1, drafts, comments, tags, news_tags  where news.id = (?)"
    
    
    -- SELECT * from (news LEFT join ( SELECT * from author LEFT join user_blog USING (id_user)) AS a ON news.id_news = a.id_user) as n LEFT join (SELECT * from category_1 LEFT join (SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id_c2) as c2 on category_1.id_c1 = c2.category_1_id) as cat on n.category_3_id = cat.id_c3
    -- SELECT * from author LEFT join user_blog ON author.user_id = user_blog.id_user;
    -- SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id
    -- SELECT * from category_1 LEFT join (SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id) as c2 on category_1.id = c2.category_1_id


    -- ALTER TABLE category_3 RENAME COLUMN id TO id_c3;