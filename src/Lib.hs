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
      create  =   PG.create
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
    user <-  getOne True "user" 1
    print user
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
    let teg = Teg 1 "testTeg"
    create True teg
   







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