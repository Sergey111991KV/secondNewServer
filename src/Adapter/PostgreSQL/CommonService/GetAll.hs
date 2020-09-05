module Adapter.PostgreSQL.CommonService.GetAll where

import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common
import  Data.Either
import  Control.Monad.Trans
import GHC.Exception.Type
import ClassyPrelude
import Data.Text
import qualified Data.ByteString.Lazy as B
import Domain.Service.Auth 
import qualified Logging.ImportLogging as Log


getAll :: (PG r m, Auth m) => SessionId -> Text -> m (Either Error [Entity])
getAll sess text  
                | text == "authors"     = do
                        access <-  findUserBySession sess
                        case access of
                           Right user -> do      
                                case (authAdmin user) of
                                        True -> do
                                                let q = "SELECT author.id_author, author.description_author, user_blog.id_user , user_blog.name_user , user_blog.last_name_user , user_blog.login , user_blog.password , user_blog.avatar , user_blog.data_create_u , user_blog.admini , user_blog.author FROM author, user_blog where author.id_user = user_blog.id_user ;"
                                                result <- (withConn $ \conn -> query_ conn q  :: IO [Author])
                                                case result of
                                                        [ ]             ->  do
                                                                        Log.logIn Log.Error $ "Error create authors" ++ (errorText DataErrorPostgreSQL)
                                                                        return $ Left DataErrorPostgreSQL
                                                        authors          ->  do
                                                                        Log.logIn Log.Debug $ "editing user authors!"   -- log
                                                                        return $ Right (convertToEntityArray authors)
                                        False -> do
                                                        Log.logIn Log.Error $ "Error create authors" ++ (errorText AccessErrorAdmin)
                                                        return $ Left AccessErrorAdmin
                           Left err -> do
                                        Log.logIn Log.Error $ "Error create authors" ++ (errorText UserErrorFindBySession)
                                        return $ Left UserErrorFindBySession
                   
                   
                                  
                | text == "users"       = do
                        let q = "SELECT * FROM user_blog ;"
                        result <- (withConn $ \conn -> query_ conn q  :: IO [User])
                        case result of
                                [ ]             ->  do
                                                Log.logIn Log.Error $ "Error create users" ++ (errorText DataErrorPostgreSQL)
                                                return $ Left DataErrorPostgreSQL
                                users         ->  do
                                                Log.logIn Log.Debug $ "editing user users!" -- log
                                                return $ Right (convertToEntityArray users)
                                      
                | text == "tags"        = do
                        let q = "SELECT (element_tags).id_teg, (element_tags).name_teg FROM tags ;"
                        result <- (withConn $ \conn -> query_ conn q  :: IO [Teg])
                        case result of
                                [ ]             ->  do
                                                Log.logIn Log.Error $ "Error create tags" ++ (errorText DataErrorPostgreSQL)
                                                return $ Left DataErrorPostgreSQL
                                tags         ->  do
                                                Log.logIn Log.Debug $ "editing user tags!"  -- log
                                                return $ Right (convertToEntityArray tags)

                | text == "news"        = do 
                     
                        result <- (withConn $ \conn -> query_ conn (fromString getAllNewsSQLText)  :: IO [News])
                        print result
                        case result of
                                [ ]             ->  do
                                                Log.logIn Log.Error $ "Error create news" ++ (errorText DataErrorPostgreSQL)
                                                return $ Left DataErrorPostgreSQL
                                news         ->  do
                                                Log.logIn Log.Debug $ "editing user news!"  -- log
                                                return $ Right (convertToEntityArray news)

                | text == "categorys1"  = do 
                        let q = "SELECT category_1.id_c1, category_1.description_cat1  FROM category_1 ;"
                        result <- (withConn $ \conn -> query_ conn q  ::IO [Category1]) 
                        case result of
                                        [ ]             ->  do
                                                        Log.logIn Log.Error $ "Error create categorys1" ++ (errorText DataErrorPostgreSQL)
                                                        return $ Left DataErrorPostgreSQL
                                        cat1         ->  do
                                                        Log.logIn Log.Debug $ "editing user categorys1!"   -- log
                                                        return $ Right (convertToEntityArray $ convertToCatEntArray cat1)

                | text == "categorys2"  = do 
                        let q = "SELECT category_2.id_c2, category_2.description_cat2, category_1.id_c1, category_1.description_cat1  FROM category_2, category_1 where category_2.category_1_id = category_1.id_c1 ;"
                        result <- (withConn $ \conn -> query_ conn q  :: IO [Category2]) 
                        case result of
                                        [ ]             ->  do
                                                        Log.logIn Log.Error $ "Error create categorys2" ++ (errorText DataErrorPostgreSQL)
                                                        return $ Left DataErrorPostgreSQL
                                        cat2         ->  do
                                                        Log.logIn Log.Debug $ "editing user categorys2!"   -- log
                                                        return $ Right (convertToEntityArray $ convertToCatEntArray cat2)

                | text == "categorys3"  = do 
                        let q = "SELECT category_3.id_c3, category_3.description_cat3, category_2.id_c2, category_2.description_cat2, category_1.id_c1, category_1.description_cat1  FROM category_3, category_2, category_1 where category_2.category_1_id = category_1.id_c1 AND category_3.category_2_id = category_2.id_c2 ;"
                        result <- (withConn $ \conn -> query_ conn q  :: IO [Category3]) 
                        case result of
                                        [ ]             ->  do
                                                        Log.logIn Log.Error $ "Error create categorys3" ++ (errorText DataErrorPostgreSQL)
                                                        return $ Left DataErrorPostgreSQL
                                        cat3         ->  do
                                                        Log.logIn Log.Debug $ "editing user categorys3!"  -- log
                                                        return $ Right (convertToEntityArray $ convertToCatEntArray cat3)

                | text == "drafts"  = do
                        access <-  findUserBySession sess
                        case access of
                           Right user -> do      
                                case (authAuthor user) of
                                        True -> do
                                                let q = "SELECT elements_draft FROM drafts, news, author where  (elements_draft).news_id_draft = news.id_news and author.id_author = news.authors_id and author.id_user = (?);"
                                                result <- (withConn $ \conn -> query conn q [(id_user user)] :: IO [Draft]) 
                                                case result of
                                                        [ ]             ->  do
                                                                        Log.logIn Log.Error $ "Error create drafts" ++ (errorText DataErrorPostgreSQL)
                                                                        return $ Left DataErrorPostgreSQL
                                                        drafts          ->  do
                                                                        Log.logIn Log.Debug $ "editing user drafts!"  -- log
                                                                        return $ Right (convertToEntityArray drafts)
                                        False -> do
                                                Log.logIn Log.Error $ "Error create drafts" ++ (errorText AccessErrorAuthor)
                                                return $ Left AccessErrorAuthor
                           Left err -> do
                                        Log.logIn Log.Error $ "Error create drafts" ++ (errorText UserErrorFindBySession)
                                        return $ Left UserErrorFindBySession

                | text == "comments"  = do
                        let q = "SELECT   (element_comment).id_comments  \
                            \ , (element_comment).text_comments \
                            \ , (element_comment).data_create_comments \
                            \ , (element_comment).news_id_comments \
                            \ , (element_comment).users_id_comments FROM comments ;"
                        result <- (withConn $ \conn -> query_ conn q  :: IO [Comment]) 
                        case result of
                                [ ]             ->  do
                                                Log.logIn Log.Error $ "Error create comments" ++ (errorText DataErrorPostgreSQL)
                                                return $ Left DataErrorPostgreSQL
                                comments         ->  do
                                                Log.logIn Log.Debug $ "editing user comments!"   -- log
                                                return $ Right (convertToEntityArray comments)
               
