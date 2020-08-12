module Adapter.PostgreSQL.CommonService.Remove where

import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common
import  Data.Either
import  Control.Monad.Trans
import GHC.Exception.Type
import ClassyPrelude
import Data.Text
import qualified Data.ByteString.Lazy as B
import Domain.Service.Auth 

remove  :: PG r m => SessionId -> Text -> Int ->  m (Either Error ())
remove sess text idE 
                        | text == "tag" = do
                                access <-  findUserBySession sess
                                case access of
                                        Right user -> do      
                                          case (authAdmin user) of
                                                True -> do
                                                        let q = "DELETE FROM tags WHERE (element_tags).id_teg = (?);"
                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                        return $ case result of
                                                                0        ->  Left DataErrorPostgreSQL
                                                                1        ->  Right () 

                                                False -> return $ Left AccessErrorAdmin
                                        Left err -> return $ Left UserErrorFindBySession
                               
                        | text == "user" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                   case (authAdmin user) of
                                                        True -> do
                                                                        let q = "DELETE FROM user_blog WHERE id_user = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        return $ case result of
                                                                                0        ->  Left DataErrorPostgreSQL
                                                                                1        ->  Right () 
                                                        False -> return $ Left AccessErrorAdmin
                                                Left err -> return $ Left UserErrorFindBySession
                               
                        | text == "author" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                   case (authAdmin user) of
                                                        True -> do
                                                                        let q = "DELETE FROM author WHERE id_author = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        return $ case result of
                                                                                0        ->  Left DataErrorPostgreSQL
                                                                                1        ->  Right () 
                                                        False -> return $ Left AccessErrorAdmin
                                                Left err -> return $ Left UserErrorFindBySession

                               
                        | text == "category1" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                   case (authAdmin user) of
                                                        True -> do
                                                                        let q = "DELETE FROM category_1 WHERE id_c1 = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        return $ case result of
                                                                            0        ->  Left DataErrorPostgreSQL
                                                                            1        ->  Right ()
                                                        False -> return $ Left AccessErrorAdmin
                                                Left err -> return $ Left UserErrorFindBySession
                                 
                        | text == "category2" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                   case (authAdmin user) of
                                                        True -> do
                                                                        let q = " DELETE FROM category_2 WHERE id_c2 = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        print result
                                                                        return $ case result of
                                                                            0        ->  Left DataErrorPostgreSQL
                                                                            1        ->  Right ()
                                                        False -> return $ Left AccessErrorAdmin
                                                Left err -> return $ Left UserErrorFindBySession
                                
                        | text == "category3" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                   case (authAdmin user) of
                                                        True -> do
                                                                        let q = "DELETE FROM category_3 WHERE id_c3 = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        return $ case result of
                                                                                0        ->  Left DataErrorPostgreSQL
                                                                                1        ->  Right () 
                                                        False -> return $ Left AccessErrorAdmin
                                                Left err -> return $ Left UserErrorFindBySession
                                
                        | text == "comment" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                   case (authAdmin user) of
                                                        True -> do
                                                                        let q = "DELETE FROM comments WHERE (element_comment).id_comments = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        return $ case result of
                                                                                0        ->  Left DataErrorPostgreSQL
                                                                                1        ->  Right () 
                                                        False -> return $ Left AccessErrorAdmin
                                                Left err -> return $ Left UserErrorFindBySession
                               
                        | text == "draft" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                   case (authAuthor user) of
                                                        True -> do
                                                                        let q = "DELETE FROM drafts USING news, author WHERE (elements_draft).news_id_draft = news.id_news and author.id_author = news.authors_id and author.id_user = (?) and (elements_draft).id_draft = (?);"
                                                                        result <- withConn $ \conn -> execute conn q ((id_user user),idE)
                                                                        return $ case result of
                                                                                0        ->  Left DataErrorPostgreSQL
                                                                                1        ->  Right () 
                                                        False -> return $ Left AccessErrorAdmin
                                                Left err -> return $ Left UserErrorFindBySession
                        | text == "news" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                   case (authAdmin user) of
                                                        True -> do
                                                                        let q = "DELETE FROM news WHERE id_news = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        return $ case result of
                                                                                0        ->  Left DataErrorPostgreSQL
                                                                                1        ->  Right () 
                                                        False -> return $ Left AccessErrorAdmin
                                                Left err -> return $ Left UserErrorFindBySession
                                
                                                                    

