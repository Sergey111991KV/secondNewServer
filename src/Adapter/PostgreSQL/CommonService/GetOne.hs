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
import qualified Logging.ImportLogging as Log


getOne :: PG r m => SessionId -> Text -> Int ->  m (Either Error  Entity)
getOne sess text idE
                    | text == "news" = do
                            let q = fromString $ ClassyPrelude.init (impureNonNull getAllNewsSQLText) ++ " where endNews.id_news = (?);"
                            i <- withConn $ \conn -> query conn q [idE] :: IO [News]
                            print i
                            case i of
                                    [x]     -> do
                                                Log.logIn Log.Debug "getOne news good!"  -- log
                                                return $ Right $ convertToEntity x 
                                           
                                    []      -> do
                                                Log.logIn Log.Error $ "Error getOne news" ++ errorText DataErrorPostgreSQL
                                                return $ Left DataErrorPostgreSQL
                    | text == "author" = do
                        access <-  findUserBySession sess
                        case access of
                           Right user -> do      
                                if authAdmin user then
                                        do
                                                let q = "SELECT author.id_author, author.description_author, user_blog.id_user , user_blog.name_user , user_blog.last_name_user , user_blog.login , user_blog.password , user_blog.avatar , user_blog.data_create_u , user_blog.admini , user_blog.author FROM author, user_blog where author.id_user = user_blog.id_user AND author.id_user = (?)"
                                                i <- withConn $ \conn -> query conn q [idE] :: IO [Author]
                                                case i of
                                                        [x]     -> do
                                                                Log.logIn Log.Debug "getOne author good!"  -- log
                                                                return $ Right $ convertToEntity x 
                                       
                                                        []      -> do
                                                                Log.logIn Log.Error $ "Error getOne author" ++ errorText DataErrorPostgreSQL
                                                                return $ Left DataErrorPostgreSQL
                                else
                                        do
                                                Log.logIn Log.Error $ "Error getOne author" ++ errorText AccessErrorAdmin
                                                return $ Left AccessErrorAdmin
                           Left err -> do
                                        Log.logIn Log.Error $ "Error getOne author" ++ errorText UserErrorFindBySession
                                        return $ Left UserErrorFindBySession


                    | text == "category1" = do
                            let q = "SELECT category_1.id_c1, category_1.description_cat1  FROM category_1 where category_1.id_c1 = (?)"
                            i <- withConn $ \conn -> query conn q [idE] :: IO [Category1]
                            case i of
                                    [x]     -> do
                                                Log.logIn Log.Debug  "getOne category1 good!"  -- log
                                                return $ Right $ convertToEntity (CatCategory1 x) 
                                           
                                    []      -> do
                                                Log.logIn Log.Error $ "Error getOne category1" ++ errorText DataErrorPostgreSQL
                                                return $ Left DataErrorPostgreSQL
                    | text == "category2" = do
                            let q = "SELECT category_2.id_c2, category_2.description_cat2, category_1.id_c1, category_1.description_cat1  FROM category_2, category_1 where category_2.id_c2 = (?) AND category_2.category_1_id = category_1.id_c1"
                            i <- withConn $ \conn -> query conn q [idE] :: IO [Category2]
                            case i of
                                    [x]     -> do
                                                Log.logIn Log.Debug  "getOne category2 good!"  -- log
                                                return $ Right $ convertToEntity (CatCategory2 x) 
                                           
                                    []      -> do
                                                Log.logIn Log.Error $ "Error getOne category2" ++ errorText DataErrorPostgreSQL
                                                return $ Left DataErrorPostgreSQL
                    | text == "category3" = do
                            let q = "SELECT category_3.id_c3, category_3.description_cat3, category_2.id_c2, category_2.description_cat2, category_1.id_c1, category_1.description_cat1  FROM category_3, category_2, category_1 where category_3.id_c3 = (?) AND category_2.category_1_id = category_1.id_c1 AND category_3.category_2_id = category_2.id_c2"
                            i <- withConn $ \conn -> query conn q [idE] :: IO [Category3]
                            case i of
                                    [x]     -> do
                                                Log.logIn Log.Debug "getOne category3 good!"  -- log
                                                return $ Right $ convertToEntity (CatCategory3 x) 
                                           
                                    []      -> do
                                                Log.logIn Log.Error $ "Error getOne category3" ++ errorText DataErrorPostgreSQL
                                                return $ Left DataErrorPostgreSQL
                    | text == "draft" = do
                            access <-  findUserBySession sess
                            case access of
                                        Right user -> do      
                                                if authAuthor user then
                                                        do
                                                                let q = "SELECT (elements_draft).id_draft \
                                                                \ , (elements_draft).text_draft , (elements_draft).data_create_draft \
                                                                \ , (elements_draft).news_id_draft , (elements_draft).main_photo_url \
                                                                \ , (elements_draft).other_photo_url , (elements_draft).short_name FROM drafts, news, author where  (elements_draft).news_id_draft = news.id_news and author.id_author = news.authors_id and author.id_user = (?) and (elements_draft).id_draft = (?);"
                                                                result <- withConn $ \conn -> query conn q (id_user user,idE) :: IO [Draft]
                                                                case result of
                                                                        [x]     -> do
                                                                                        Log.logIn Log.Debug  "getOne draft good!"  -- log
                                                                                        return $ Right $ convertToEntity x 
                                                                        []      -> do
                                                                                        Log.logIn Log.Error $ "Error getOne draft" ++ errorText DataErrorPostgreSQL
                                                                                        return $ Left DataErrorPostgreSQL
                                                else
                                                        do
                                                                Log.logIn Log.Error $ "Error getOne draft" ++ errorText AccessErrorAuthor
                                                                return $ Left AccessErrorAuthor
                                        Left err -> do
                                                Log.logIn Log.Error $ "Error getOne draft" ++ errorText UserErrorFindBySession
                                                return $ Left UserErrorFindBySession

                    | text == "comment" = do
                        let q = "SELECT   (element_comment).id_comments  \
                            \ , (element_comment).text_comments \
                            \ , (element_comment).data_create_comments \
                            \ , (element_comment).news_id_comments \
                            \ , (element_comment).users_id_comments FROM comments where (element_comment).id_comments = (?)"
                        i <- withConn $ \conn -> query conn q [idE] :: IO [Comment]
                        case i of
                                [x]     -> do
                                                Log.logIn Log.Debug "getOne comment good!"  -- log
                                                return $ Right $ convertToEntity x 
                                       
                                []      -> do
                                                Log.logIn Log.Error $ "Error getOne comment" ++ errorText DataErrorPostgreSQL
                                                return $ Left DataErrorPostgreSQL

                    | text == "tag" = do
                        let q = "SELECT   (element_tags).id_teg  \
                            \ , (element_tags).name_teg FROM tags where (element_tags).id_teg = (?)"
                        i <- withConn $ \conn -> query conn q [idE] :: IO [Teg] 
                        case i of
                                [x]     -> do
                                                Log.logIn Log.Debug "getOne tag good!"  -- log
                                                return $ Right (convertToEntity x) 
                                       
                                []      -> do
                                                Log.logIn Log.Error $ "Error getOne tag" ++ errorText DataErrorPostgreSQL
                                                return $ Left DataErrorPostgreSQL
                    | text == "user" = do
                        let q = "SELECT * FROM user_blog where id_user = (?)"
                        i <- withConn $ \conn -> query conn q [idE] :: IO [User]
                        case i of
                                [x]     -> do
                                                Log.logIn Log.Debug "getOne user good!"  -- log
                                                return $ Right (convertToEntity x) 
                                       
                                []      -> do
                                                Log.logIn Log.Error $ "Error getOne user" ++ errorText DataErrorPostgreSQL
                                                return $ Left DataErrorPostgreSQL

