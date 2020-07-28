module Adapter.PostgreSQL.CommonService where

import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common
import  Data.Either
import  Control.Monad.Trans
import GHC.Exception.Type
import ClassyPrelude
import Data.Text
import qualified Data.ByteString.Lazy as B



                                    -- Get All

getAll :: PG r m => Bool -> Text -> m (Either Error [Entity])
getAll access text  
                | text == "authors"     = do
                    let q = "SELECT author.id_author, author.description_author, user_blog.id_user , user_blog.name_user , user_blog.last_name_user , user_blog.login , user_blog.password , user_blog.avatar , user_blog.data_create_u , user_blog.admini , user_blog.author FROM author, user_blog ;"
                    result <- (withConn $ \conn -> query_ conn q  :: IO [Author])
                    return $ case result of
                            [ ]             ->  Left DataErrorPostgreSQL
                            authors          ->  Right (convertToEntityArray authors)
                                  
                | text == "users"       = do
                        let q = "SELECT * FROM user_blog ;"
                        result <- (withConn $ \conn -> query_ conn q  :: IO [User])
                        return $ case result of
                                [ ]             ->  Left DataErrorPostgreSQL
                                users         ->  Right (convertToEntityArray users)
                                      
                | text == "tags"        = do
                        let q = "SELECT (element_tags).id_teg, (element_tags).name_teg FROM tags ;"
                        result <- (withConn $ \conn -> query_ conn q  :: IO [Teg])
                        return $ case result of
                                [ ]             ->  Left DataErrorPostgreSQL
                                tags         ->  Right (convertToEntityArray tags)

                | text == "news"        = do 
                     
                        result <- (withConn $ \conn -> query_ conn (fromString getAllNewsSQLText)  :: IO [News])
                        return $ case result of
                                [ ]             ->  Left DataErrorPostgreSQL
                                news         ->  Right (convertToEntityArray news)

                | text == "categorys1"  = do 
                        let q = "SELECT category_1.id_c1, category_1.description_cat1  FROM category_1 ;"
                        result <- (withConn $ \conn -> query_ conn q  ::IO [Category1]) 
                        return $ case result of
                                        [ ]             ->  Left DataErrorPostgreSQL
                                        cat1         ->  Right (convertToEntityArray $ convertToCatEntArray cat1)

                | text == "categorys2"  = do 
                        let q = "SELECT category_2.id_c2, category_2.description_cat2, category_1.id_c1, category_1.description_cat1  FROM category_2, category_1 where category_2.category_1_id = category_1.id_c1 ;"
                        result <- (withConn $ \conn -> query_ conn q  :: IO [Category2]) 
                        return $ case result of
                                        [ ]             ->  Left DataErrorPostgreSQL
                                        cat2         ->  Right (convertToEntityArray $ convertToCatEntArray cat2)

                | text == "categorys3"  = do 
                        let q = "SELECT category_3.id_c3, category_3.description_cat3, category_2.id_c2, category_2.description_cat2, category_1.id_c1, category_1.description_cat1  FROM category_3, category_2, category_1 where category_2.category_1_id = category_1.id_c1 AND category_3.category_2_id = category_2.id_c2 ;"
                        result <- (withConn $ \conn -> query_ conn q  :: IO [Category3]) 
                        return $ case result of
                                        [ ]             ->  Left DataErrorPostgreSQL
                                        cat3         ->  Right (convertToEntityArray $ convertToCatEntArray cat3)

                | text == "drafts"  = do
                        let q = "SELECT   (elements_draft).id_draft  \
                        \ , (elements_draft).text_draft \
                        \ , (elements_draft).data_create_draft \
                        \ , (elements_draft).news_id_draft \
                        \ , (elements_draft).main_photo_url \
                        \ , (elements_draft).other_photo_url \
                        \ , (elements_draft).short_name FROM drafts ;"
                        result <- (withConn $ \conn -> query_ conn q  :: IO [Draft]) 
                        return $ case result of
                            [ ]             ->  Left DataErrorPostgreSQL
                            drafts         ->  Right (convertToEntityArray drafts)

                | text == "comments"  = do
                        let q = "SELECT   (element_comment).id_comments  \
                            \ , (element_comment).text_comments \
                            \ , (element_comment).data_create_comments \
                            \ , (element_comment).news_id_comments \
                            \ , (element_comment).users_id_comments FROM comments ;"
                        result <- (withConn $ \conn -> query_ conn q  :: IO [Comment]) 
                        return $ case result of
                                [ ]             ->  Left DataErrorPostgreSQL
                                comments         ->  Right (convertToEntityArray comments)
                



--                                  Get One






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



--                          Create




create  :: PG r m => Bool -> Entity  -> m (Either Error ())
create access (EntAuthor  auth)  = do
        let q = "INSERT INTO author (id_author, description_author, id_user) VALUES (?,?,?);"
        result <- withConn $ \conn -> execute conn q ((id_author auth), (description auth), (id_user $ user auth) )
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

create access (EntUser  us)  = do
        let q = "INSERT INTO user_blog  VALUES (?,?,?,?,?,?,?,?,?);"
        result <- withConn $ \conn -> execute conn q us
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL
            
create access (EntCategory (CatCategory1 cat))  = do
        let q = "INSERT INTO category_1 (id_c1, description_cat1) VALUES (?,?);"
        result <- withConn $ \conn -> execute conn q (id_category_1 cat, name_category_1 cat )
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

create access (EntCategory (CatCategory2 cat))  = do
        let q = "INSERT INTO category_2 (id_c2, description_cat2, category_1_id) VALUES (?,?,?);"
        result <- withConn $ \conn -> execute conn q (id_category_2 cat, name_category_2 cat , (id_category_1 $ category1 cat))
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

create access (EntCategory (CatCategory3 cat))  = do
        let q = "INSERT INTO category_3 (id_c3, description_cat3, category_2_id) VALUES (?,?,?);"
        result <- withConn $ \conn -> execute conn q (id_category_3 cat, name_category_3 cat , (id_category_2 $ category2 cat))
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

create access (EntComment  com)                 = do
        let q = "INSERT INTO comments (element_comment) VALUES((?,?,?,?,?));"
        result <- withConn $ \conn -> execute conn q com
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

create access (EntDraft    draft)               = do
        let q = "INSERT INTO drafts (elements_draft) VALUES((?,?,?,?,?,?,?));"
        result <- withConn $ \conn -> execute conn q draft
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

create access (EntTeg      teg)                 = do
        let q = "INSERT INTO tags (element_tags) VALUES((?,?));"
        result <- withConn $ \conn -> execute conn q teg
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

create access (EntNews     news)                = do
        let q = "INSERT INTO news VALUES (?,?,?,?,?,?,?,?);"
        result <- withConn $ \conn -> execute conn q ( (id_news news)
                                                     , (data_create_news news)
                                                     , (id_author $ authors news)
                                                     , (id_category_3 $ category news)
                                                     , (text_news news)
                                                     , (main_photo_url_news news)
                                                     , (other_photo_url_news news)
                                                     , (short_name_news news)
                                                    )                            
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL




--                                  Remove


                
remove  :: PG r m => Bool -> Text -> Int ->  m (Either Error ())
remove access text idE 
                        | text == "tag" = do
                                let q = "DELETE FROM tags WHERE (element_tags).id_teg = (?);"
                                result <- withConn $ \conn -> execute conn q [idE]
                                return $ case result of
                                        0        ->  Left DataErrorPostgreSQL
                                        1        ->  Right () 

                        | text == "user" = do
                                let q = "DELETE FROM user_blog WHERE id_user = (?);"
                                result <- withConn $ \conn -> execute conn q [idE]
                                return $ case result of
                                        0        ->  Left DataErrorPostgreSQL
                                        1        ->  Right () 
                        | text == "author" = do
                                let q = "DELETE FROM author WHERE id_author = (?);"
                                result <- withConn $ \conn -> execute conn q [idE]
                                return $ case result of
                                        0        ->  Left DataErrorPostgreSQL
                                        1        ->  Right () 
                        | text == "category1" = do
                                let q = "DELETE FROM category_1 WHERE id_c1 = (?);"
                                result <- withConn $ \conn -> execute conn q [idE]
                                return $ case result of
                                    0        ->  Left DataErrorPostgreSQL
                                    1        ->  Right () 
                        | text == "category2" = do
                                let q = " DELETE FROM category_2 WHERE id_c2 = (?);"
                                result <- withConn $ \conn -> execute conn q [idE]
                                print result
                                return $ case result of
                                    0        ->  Left DataErrorPostgreSQL
                                    1        ->  Right () 
                        | text == "category3" = do
                                let q = "DELETE FROM category_3 WHERE id_c3 = (?);"
                                result <- withConn $ \conn -> execute conn q [idE]
                                return $ case result of
                                        0        ->  Left DataErrorPostgreSQL
                                        1        ->  Right () 
                        | text == "comment" = do
                                let q = "DELETE FROM comments WHERE (element_comment).id_comments = (?);"
                                result <- withConn $ \conn -> execute conn q [idE]
                                return $ case result of
                                        0        ->  Left DataErrorPostgreSQL
                                        1        ->  Right () 
                        | text == "draft" = do
                                let q = "DELETE FROM drafts WHERE (elements_draft).id_draft = (?);"
                                result <- withConn $ \conn -> execute conn q [idE]
                                return $ case result of
                                        0        ->  Left DataErrorPostgreSQL
                                        1        ->  Right () 
                        | text == "news" = do
                                let q = "DELETE FROM news WHERE id_news = (?);"
                                result <- withConn $ \conn -> execute conn q [idE]
                                return $ case result of
                                        0        ->  Left DataErrorPostgreSQL
                                        1        ->  Right () 
                                                                    






--                                      Editing



editing  :: PG r m =>  Bool -> Entity -> m (Either Error ())
editing access (EntTeg      teg)                 = do
        let q  = "UPDATE tags SET element_tags.name_teg = (?) WHERE (element_tags).id_teg = (?);"
        result <- withConn $ \conn -> execute conn q ((name_teg teg), (id_teg teg))
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL
            
editing access (EntAuthor      auth)                 = do
        let q  = "UPDATE author SET  description_author = (?), id_user = (?)  WHERE id_author = (?) ;"
        result <- withConn $ \conn -> execute conn q ((description auth), (id_user $ user $ auth), (id_author auth))
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

editing access (EntCategory (CatCategory1 cat1))                 = do
        let q  = "UPDATE category_1 SET  description_cat1 = (?)  WHERE id_c1 = (?) ;"
        result <- withConn $ \conn -> execute conn q ((name_category_1 cat1), (id_category_1 cat1))
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL
editing access (EntCategory (CatCategory2 cat2))                 = do
        let q  = "UPDATE category_2 SET  description_cat2 = (?)  WHERE id_c2 = (?) ;"
        result <- withConn $ \conn -> execute conn q ((name_category_2 cat2), (id_category_2 cat2))
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL
editing access (EntCategory (CatCategory3 cat3))                 = do
        let q  = "UPDATE category_3 SET  description_cat3 = (?)  WHERE id_c3 = (?) ;"
        result <- withConn $ \conn -> execute conn q ((name_category_3 cat3), (id_category_3 cat3))
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL
editing access ( EntComment  com )                 = do
        let q  = "UPDATE comments SET  element_comment.text_comments = (?) \
                                    \ , element_comment.data_create_comments = (?) \
                                    \ , element_comment.news_id_comments = (?) \
                                    \ , element_comment.users_id_comments = (?) \
                                    \    WHERE (element_comment).id_comments = (?)  ;"
        result <- withConn $ \conn -> execute conn q (  (text_comments com)
                                                     ,  (data_create_comments com)
                                                     ,  (news_id_comments com)
                                                     ,  (users_id_comments com)
                                                     , (id_comments com))
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

editing access (EntDraft    draft )                 = do
        let q  =    "UPDATE drafts SET    elements_draft.text_draft = (?) \
                                        \ , elements_draft.data_create_draft = (?) \
                                        \ , elements_draft.news_id_draft = (?) \
                                        \ , elements_draft.main_photo_url = (?) \
                                        \ , elements_draft.other_photo_url = (?) \
                                        \ , elements_draft.short_name = (?) \
                                        \    WHERE (elements_draft).id_draft = (?)  ;"
        result <- withConn $ \conn -> execute conn q    (  (text_draft draft)   
                                                ,  (data_create_draft draft)
                                                ,  (news_id_draft draft)
                                                ,  (main_photo_url draft)
                                                ,  (other_photo_url draft)
                                                ,  (short_name draft)
                                                ,  (id_draft draft))
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL
editing access ( EntNews     news)                 = do
        let q  = "UPDATE news SET       data_create_n = (?) \
                                        \ , authors_id = (?) \
                                        \ , category_3_id = (?) \
                                        \ , description_news = (?) \
                                        \ , main_photo_url_n = (?) \
                                        \ , other_photo_url_n = (?) \
                                        \ , short_name_n = (?) \
                                        \    WHERE id_news = (?)  ;"
        result <- withConn $ \conn -> execute conn q (  
                            (data_create_news news)
                         ,  (id_author $ authors news)
                         ,  (id_category_3 $ category news)
                         ,  (text_news news)
                         ,  (main_photo_url_news news)
                         ,  (other_photo_url_news news)
                         ,  (short_name_news news)
                         ,  (id_news news))
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

editing access (EntUser    user )                 = do
        let q  = "UPDATE user_blog SET       name_user = (?) \
                                        \ , last_name_user = (?) \
                                        \ , login = (?) \
                                        \ , password = (?) \
                                        \ , avatar = (?) \
                                        \ , data_create_u = (?) \
                                        \ , admini = (?) \
                                        \ , author = (?) \
                                        \    WHERE id_user = (?)  ;"
        result <- withConn $ \conn -> execute conn q (  
                            (nameU user)
                         ,  (lastName user)
                         ,  (authLogin user)
                         ,  (authPassword user)
                         ,  (avatar user)
                         ,  (dataCreate user)
                         ,  (authAdmin user)
                         ,  (authAuthor user)
                         ,  (id_user user))
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

