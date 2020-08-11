module Adapter.PostgreSQL.Common where

import Domain.ImportEntity 


import Data.Has
import Data.Pool
import Data.ByteString
import Control.Monad.Catch 
import Control.Monad.Reader
import Control.Monad.IO.Class
import ClassyPrelude

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
        Control.Monad.Catch.bracket initPool cleanPool action
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

getAllNewsSQLText :: String
getAllNewsSQLText = 
  "SELECT endNews.id_news \
		\ , endNews.data_create_n \
		\ , endNews.id_author, endNews.description_author, endNews.id_user, endNews.name_user, endNews.last_name_user, endNews.login \
		\ , endNews.password, endNews.avatar, endNews.data_create_u, endNews.admini, endNews.author \
    \ , endNews.id_c3, endNews.description_cat3, endNews.id_c2, endNews.description_cat2, endNews.id_c1, endNews.description_cat1 \
    \ , endNews.description_news , endNews.main_photo_url_n \
    \ , endNews.other_photo_url_n \
    \ , endNews.short_name_n \
    \ , ARRAY (SELECT * FROM drafts where  endNews.id_news = (elements_draft).news_id_draft) \
    \ , ARRAY(SELECT  * FROM comments where endNews.id_news = (element_comment).news_id_comments  ) \
    \ , ARRAY(SELECT * FROM tags where endNews.id_news = news_tags.news_id) \
    \ from news_tags, ( select * from (news LEFT join ( SELECT * from author LEFT join user_blog USING (id_user)) as a ON news.authors_id = a.id_author) as newsAuthor \
    \  LEFT join (SELECT * from category_1 LEFT join (SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id_c2) as c2 on category_1.id_c1 = c2.category_1_id) as cat on newsAuthor.category_3_id = cat.id_c3) \
    \ as endNews "
                               

getAllNewsSQLTextOneTeg :: String
getAllNewsSQLTextOneTeg = "SELECT  n.id_news,  n.data_create_n \
                                  \ , n.id_author, n.description_author, n.id_user, n.name_user, n.last_name_user, n.login, n.password, n.avatar, n.data_create_u, n.admini, n.author \
                                  \ , cat.id_c3, cat.description_cat3, cat.id_c2, cat.description_cat2, cat.id_c1, cat.description_cat1 \
                                  \ , n.description_news \
                                  \ , n.main_photo_url_n \
                                  \ , n.other_photo_url_n \
                                  \ , n.short_name_n  \
                                  \ , ARRAY (SELECT  ((elements_draft).id_draft, (elements_draft).text_draft , (elements_draft).data_create_draft , (elements_draft).news_id_draft , (elements_draft).main_photo_url , (elements_draft).other_photo_url , (elements_draft).short_name  ) FROM drafts where (elements_draft).news_id_draft = n.id_news ) \
                                  \ , ARRAY(SELECT  ((element_comment).id_comments, (element_comment).text_comments , (element_comment).data_create_comments , (element_comment).news_id_comments , (element_comment).users_id_comments) FROM comments where (element_comment).news_id_comments = n.id_news ) \
                                  \ , ARRAY(SELECT  ((element_tags).id_teg, (element_tags).name_teg) FROM tags, news_tags where (element_tags).id_teg  = news_tags.tags_id and n.id_news = news_tags.news_id)  \
                                  \ from (SELECT * from (SELECT * from news_tags LEFT join news AS tegnews on news_tags.news_id = tegnews.id_news) \
                                        \ as tt LEFT join ( SELECT * from author LEFT join user_blog USING (id_user)) \
                                        \ as a ON  tt.authors_id = a.id_author) as n LEFT join (SELECT * from category_1 LEFT join (SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id_c2) \
                                        \ as c2 on category_1.id_c1 = c2.category_1_id) as cat on n.category_3_id = cat.id_c3 \
                                        \ where n.tags_id = (?);"



                                      --   CREATE TABLE news (
                                      --     id_news integer DEFAULT nextval('news_id_seq'::regclass) PRIMARY KEY,
                                      --     data_create_n timestamp with time zone,
                                      --     authors_id integer,
                                      --     category_3_id integer REFERENCES category_3(id_c3),
                                      --     description_news text,
                                      --     main_photo_url_n text,
                                      --     other_photo_url_n text[],
                                      --     short_name_n text NOT NULL
                                      -- );
                                      
                                      -- Indices -------------------------------------------------------
                                      
                                      -- CREATE UNIQUE INDEX news_pkey ON news(id_news int4_ops);
--                                       CREATE TABLE drafts (
--     elements_draft drafts_type1
-- );
-- CREATE TABLE comments (
--     element_comment comment_type1
-- );

