module Adapter.PostgreSQL.CommonService where



import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common
import  Data.Either
import  Control.Monad.Trans
import GHC.Exception.Type
import ClassyPrelude


-- getAll :: PG r m => Bool -> Text -> m (Either Error [Entity])
-- getAll access text  
--                 | text == "authors"     = do
--                     let q = "SELECT * FROM author"
--                     result <- (withConn $ \conn -> query_ conn q  :: IO [Author'])
--                     case result of
--                             [ ]             ->  return $ Left DataErrorPostgreSQL
--                             authors'            -> do
--                                     newResult <- convertToAuthorArray authors'
--                                     return $ case newResult of
--                                         Left err    ->  Left err
--                                         Right auth  ->  Right auth
--                 | text == "users"       = do
--                     let q = "SELECT * FROM user_blog"
--                     result <- (withConn $ \conn -> query_ conn q  :: IO [User])
--                     let newResult = fmap convertToEntity result
--                     case newResult of
--                             [ ]             ->  return $ Left DataErrorPostgreSQL
--                             newResult       ->  return $ Right newResult   
--                 | text == "tegs"        = do
--                     let q = "SELECT * FROM tags"
--                     result <- (withConn $ \conn -> query_ conn q  :: IO [Teg])
--                     let newResult = fmap convertToEntity result
--                     case newResult of
--                             [ ]             ->  return $ Left DataErrorPostgreSQL
--                             newResult       ->  return $ Right newResult   
--                 | text == "news"        = do 
--                     let q = "SELECT * FROM news"
--                     result <- (withConn $ \conn -> query_ conn q  :: IO [News'])
--                     case result of
--                         [ ]             ->  return $ Left DataErrorPostgreSQL
--                         news'            -> do
--                                 newResult <- convertToNewsArray news'
--                                 return $ case newResult of
--                                     Left err    ->  Left err
--                                     Right news  ->  Right news
--                 | text == "categorys1"  = do 
--                     let q = "SELECT * FROM category_1"
--                     result <- (withConn $ \conn -> query_ conn q  :: IO [Category1'])
--                     case result of
--                         [ ]             ->  return $ Left DataErrorPostgreSQL
--                         result            -> do
--                                 let catArray = fmap convertToCategory result
--                                 newResult <- convertToCategoryPostgressArray catArray
--                                 return $ case newResult of
--                                     Left err    ->  Left err
--                                     Right cat  ->  Right cat
--                 | text == "categorys2"  = do 
--                         let q = "SELECT * FROM category_2"
--                         result <- (withConn $ \conn -> query_ conn q  :: IO [Category2'])
--                         case result of
--                             [ ]             ->  return $ Left DataErrorPostgreSQL
--                             result            -> do
--                                     let catArray = fmap convertToCategory result
--                                     newResult <- convertToCategoryPostgressArray catArray
--                                     return $ case newResult of
--                                         Left err    ->  Left err
--                                         Right cat  ->  Right cat
--                 | text == "categorys3"  = do 
--                         let q = "SELECT * FROM category_3"
--                         result <- (withConn $ \conn -> query_ conn q  :: IO [Category3'])
--                         case result of
--                             [ ]             ->  return $ Left DataErrorPostgreSQL
--                             result            -> do
--                                     let catArray = fmap convertToCategory result
--                                     newResult <- convertToCategoryPostgressArray catArray
--                                     return $ case newResult of
--                                         Left err    ->  Left err
--                                         Right cat  ->  Right cat
                -- | text == "drafts"  = do
                --         let q = "SELECT * FROM drafts"
                --         result <- (withConn $ \conn -> query_ conn q  :: IO [Draft])
                --         let newResult = fmap convertToEntity result
                --         case newResult of
                --                 [ ]             ->  return $ Left DataErrorPostgreSQL
                --                 newResult       ->  return $ Right newResult 
--                 | text == "comments"  = do
--                         let q = "SELECT * FROM comments"
--                         result <- (withConn $ \conn -> query_ conn q  :: IO [Comment])
--                         let newResult = fmap convertToEntity result
--                         case newResult of
--                                 [ ]             ->  return $ Left DataErrorPostgreSQL
--                                 newResult       ->  return $ Right newResult 
                


getOne :: PG r m => Bool -> Text -> Int ->  m (Either Error  Entity)
getOne access text idE
                    | text == "news" = do
                            let q = "SELECT n.id_news, \
                                    \ n.data_create_n, \
                                    \ n.id_author, n.description_author, n.id_user, n.name_user, n.last_name_user, n.login, n.password, n.avatar, n.data_create_u, n.admini, n.author , \
                                    \ cat.id_c3, cat.description_cat3, cat.id_c2, cat.description_cat2, cat.id_c1, cat.description_cat1 , \
                                    \ n.description_news , \
                                    \ n.main_photo_url_n , \
                                    \ n.other_photo_url_n  , \
                                    \ n.short_name_n \
                                    \ , ARRAY (SELECT row ((elements_draft).id_draft, (elements_draft).text_draft , (elements_draft).data_create_draft , (elements_draft).news_id_draft , (elements_draft).main_photo_url , (elements_draft).other_photo_url , (elements_draft).short_name  ) FROM drafts where (elements_draft).news_id_draft = n.id_news ) \
                                    \ , ARRAY(SELECT ROW ((element_comment).id_comments, (element_comment).text_comments , (element_comment).data_create_comments , (element_comment).news_id_comments , (element_comment).users_id_comments) FROM comments where (element_comment).news_id_comments = n.id_news ) \
                                    \ , ARRAY(SELECT ROW ((element_tags).id_teg, (element_tags).name_teg) FROM tags where (element_tags).id_teg  = n.id_news ) \
                                    \ from (news LEFT join ( SELECT * from author LEFT join user_blog USING (id_user)) AS a ON news.id_news = a.id_user) as n LEFT join (SELECT * from category_1 LEFT join (SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id_c2) as c2 on category_1.id_c1 = c2.category_1_id) as cat on n.category_3_id = cat.id_c3 \
                                    \ where n.id_news = (?)"
                            i <- (withConn $ \conn -> query conn q [idE] :: IO [News]) 
                            print i
                            return $ case i of
                                    [x]     -> Right $ convertToEntity x 
                                           
                                    []      -> Left DataErrorPostgreSQL
                    | text == "author" = do
                        -- let q = "SELECT author.id, author.description, user_blog.id_user , user_blog.name , user_blog.last_name , user_blog.login , user_blog.password , user_blog.avatar , user_blog.data_create , user_blog.admini , user_blog.author FROM author JOIN user_blog where author.user_id = user_blog.id_user"
                        let q = "SELECT author.id_author, author.description_author, user_blog.id_user , user_blog.name_user , user_blog.last_name_user , user_blog.login , user_blog.password , user_blog.avatar , user_blog.data_create_u , user_blog.admini , user_blog.author FROM author, user_blog where author.id_user = user_blog.id_user AND author.id_user = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [Author]) 
                        return $ case i of
                                [x]     -> Right $ convertToEntity x 
                                       
                                []      -> Left DataErrorPostgreSQL


                    | text == "category1" = do
                            let q = "SELECT category_1.id_c1, category_1.description_cat1  FROM category_1 where category_1.id_c1 = (?)"
                            i <- (withConn $ \conn -> query conn q [idE] :: IO [Category1]) 
                            return $ case i of
                                    [x]     -> Right $ convertToEntity (CatCategory1 x) 
                                           
                                    []      -> Left DataErrorPostgreSQL
                    | text == "category2" = do
                            let q = "SELECT category_2.id_c2, category_2.description_cat2, category_1.id_c1, category_1.description_cat1  FROM category_2, category_1 where category_2.id_c2 = (?) AND category_2.category_1_id = category_1.id_c1"
                            i <- (withConn $ \conn -> query conn q [idE] :: IO [Category2]) 
                            return $ case i of
                                    [x]     -> Right $ convertToEntity (CatCategory2 x) 
                                           
                                    []      -> Left DataErrorPostgreSQL
                    | text == "category3" = do
                            let q = "SELECT category_3.id_c3, category_3.description_cat3, category_2.id_c2, category_2.description_cat2, category_1.id_c1, category_1.description_cat1  FROM category_3, category_2, category_1 where category_3.id_c3 = (?) AND category_2.category_1_id = category_1.id_c1 AND category_3.category_2_id = category_2.id_c2"
                            i <- (withConn $ \conn -> query conn q [idE] :: IO [Category3]) 
                            return $ case i of
                                    [x]     -> Right $ convertToEntity (CatCategory3 x) 
                                           
                                    []      -> Left DataErrorPostgreSQL
                    | text == "draft" = do
                        let q = "SELECT   (elements_draft).id_draft  \
                            \ , (elements_draft).text_draft \
                            \ , (elements_draft).data_create_draft \
                            \ , (elements_draft).news_id_draft \
                            \ , (elements_draft).main_photo_url \
                            \ , (elements_draft).other_photo_url \
                            \ , (elements_draft).short_name FROM drafts where (elements_draft).id_draft = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [Draft]) 
                        return $ case i of
                                [x]     -> Right $ convertToEntity x 
                                       
                                []      -> Left DataErrorPostgreSQL

                    | text == "comment" = do
                        let q = "SELECT   (element_comment).id_comments  \
                            \ , (element_comment).text_comments \
                            \ , (element_comment).data_create_comments \
                            \ , (element_comment).news_id_comments \
                            \ , (element_comment).users_id_comments FROM comments where (element_comment).id_comments = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [Comment]) 
                        return $ case i of
                                [x]     -> Right $ convertToEntity x 
                                       
                                []      -> Left DataErrorPostgreSQL

                    | text == "tag" = do
                        let q = "SELECT   (element_tags).id_teg  \
                            \ , (element_tags).name_teg FROM tags where (element_tags).id_teg = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [Teg]) 
                        return $ case i of
                                [x]     -> Right (convertToEntity x) 
                                       
                                []      -> Left DataErrorPostgreSQL
                    | text == "user" = do
                        let q = "SELECT * FROM user_blog where id_user = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [User]) 
                        return $ case i of
                                [x]     -> Right (convertToEntity x) 
                                       
                                []      -> Left DataErrorPostgreSQL



create  :: PG r m => Bool -> Entity  -> m (Either Error ())
create access (EntAuthor  auth)  = undefined
create access (EntCategory (CatCategory1 cat))  = undefined
create access (EntCategory (CatCategory2 cat))  = undefined
create access (EntCategory (CatCategory3 cat))  = undefined
create access (EntComment  com)                 = undefined
create access (EntDraft    draft)               = undefined
create access (EntNews     news)                = undefined
create access (EntTeg      teg)                 = do
            let q = "INSERT INTO tags (element_tags) VALUES((1.1,2.2));"
            result <- withConn $ \conn -> execute conn q teg
            return $ case result of
                _        ->  Left DataErrorPostgreSQL
                i        ->  Right ()
       











-- "SELECT n.id_news, \
--                                     \ n.data_create_n, \
--                                     \ n.id_author, n.description_author, n.id_user, n.name_user, n.last_name_user, n.login, n.password, n.avatar, n.data_create_u, n.admini, n.author , \
--                                     \ n.id_c3, n.description_cat3, n.id_c2, n.description_cat2, n.id_c1, n.description_cat1 , \
--                                     \ n.description_news , \
--                                     \ n.main_photo_url_n , \
--                                     \ ARRAY ( SELECT n.other_photo_url_n FROM n) , \
--                                     \ n.short_name_n \
--                                     \ , ARRAY (SELECT row ((elements_draft).id_draft, (elements_draft).text_draft , (elements_draft).data_create_draft , (elements_draft).news_id_draft , (elements_draft).main_photo_url , (elements_draft).other_photo_url , (elements_draft).short_name  ) FROM drafts where (elements_draft).news_id = news.id ) \
--                                     \ , ARRAY(SELECT ROW ((element_comment).id_comments, (element_comment).text_comments , (element_comment).data_create_comments , (element_comment).news_id_comments , (element_comment).users_id_comments) FROM comments where (element_comment).news_id_comments = news.id ) \
--                                     \ , ARRAY(SELECT ROW ((element_tags).id_teg, (element_tags).name_teg) FROM tags where (element_tags).id_teg  = news.id ) \
--                                     \ from (news LEFT join ( SELECT * from author LEFT join user_blog USING (id_user)) AS a ON news.id_news = a.id_user) as n LEFT join (SELECT * from category_1 LEFT join (SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id_c2) as c2 on category_1.id_c1 = c2.category_1_id) as cat on n.category_3_id = cat.id_c3 \
--                                     \ where n.id = (?)"

                                    -- SELECT * from category_1 LEFT join (SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id_c2) as c2 on category_1.id_c1 = c2.category_1_id



    --                                 CREATE TYPE drafts_type AS(
	-- id_draft 				integer,
	-- text_draft				text,
	-- data_create_draft		timestamp, 
	-- news_id_draft			integer,
	-- main_photo_url			text,
	-- other_photo_url			text[],
    -- short_name				text );
    






    