module Adapter.PostgreSQL.CommonService.GetOne where

import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common
import  Data.Either
import  Control.Monad.Trans
import GHC.Exception.Type
import ClassyPrelude
import Data.Text
import qualified Data.ByteString.Lazy as B
import Domain.Service.Auth 


getOne :: PG r m => SessionId -> Text -> Int ->  m (Either Error  Entity)
getOne sess text idE
                    | text == "news" = do
                            let q = fromString $ (ClassyPrelude.init $ impureNonNull getAllNewsSQLText) ++ " where endNews.id_news = (?);"
                            i <- (withConn $ \conn -> query conn q [idE] :: IO [News]) 
                            print i
                            return $ case i of
                                    [x]     -> Right $ convertToEntity x 
                                           
                                    []      -> Left DataErrorPostgreSQL
                    | text == "author" = do
                        access <-  findUserBySession sess
                        case access of
                           Right user -> do      
                                case (authAdmin user) of
                                        True -> do
                                                let q = "SELECT author.id_author, author.description_author, user_blog.id_user , user_blog.name_user , user_blog.last_name_user , user_blog.login , user_blog.password , user_blog.avatar , user_blog.data_create_u , user_blog.admini , user_blog.author FROM author, user_blog where author.id_user = user_blog.id_user AND author.id_user = (?)"
                                                i <- (withConn $ \conn -> query conn q [idE] :: IO [Author]) 
                                                return $ case i of
                                                        [x]     -> Right $ convertToEntity x 
                                       
                                                        []      -> Left DataErrorPostgreSQL
                                        False -> return $ Left AccessErrorAdmin
                           Left err -> return $ Left UserErrorFindBySession


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
                            access <-  findUserBySession sess
                            case access of
                                        Right user -> do      
                                                case (authAuthor user) of
                                                        True -> do
                                                                let q = "SELECT (elements_draft).id_draft \
                                                                \ , (elements_draft).text_draft , (elements_draft).data_create_draft \
                                                                \ , (elements_draft).news_id_draft , (elements_draft).main_photo_url \
                                                                \ , (elements_draft).other_photo_url , (elements_draft).short_name FROM drafts, news, author where  (elements_draft).news_id_draft = news.id_news and author.id_author = news.authors_id and author.id_user = (?) and (elements_draft).id_draft = (?);"
                                                                result <- (withConn $ \conn -> query conn q ((id_user user),idE) :: IO [Draft]) 
                                                                return $ case result of
                                                                        [x]     -> Right $ convertToEntity x 
                                                                        []      -> Left DataErrorPostgreSQL
                                                        False -> return $ Left AccessErrorAuthor
                                        Left err -> return $ Left UserErrorFindBySession

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

