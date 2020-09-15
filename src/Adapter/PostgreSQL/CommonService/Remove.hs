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
import qualified Logging.ImportLogging as Log

remove  :: PG r m => SessionId -> Text -> Int ->  m (Either Error ())
remove sess text idE 
                        | text == "tag" = do
                                access <-  findUserBySession sess
                                case access of
                                        Right user -> do      
                                                if authAdmin user then
                                                        do
                                                        let q = "DELETE FROM tags WHERE (element_tags).id_teg = (?);"
                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                        case result of
                                                                0        ->  do
                                                                                Log.logIn Log.Error $ "Error remove tag" ++ errorText DataErrorPostgreSQL
                                                                                return $ Left DataErrorPostgreSQL
                                                                1        ->  do
                                                                                Log.logIn Log.Debug "remove tag good!"  -- log
                                                                                return $ Right () 

                                                else    
                                                        do
                                                        Log.logIn Log.Error $ "Error remove tag" ++ errorText AccessErrorAdmin
                                                        return $ Left AccessErrorAdmin
                                        Left err -> do
                                                Log.logIn Log.Error $ "Error remove tag" ++ errorText UserErrorFindBySession
                                                return $ Left UserErrorFindBySession
                               
                        | text == "user" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                        if authAdmin user then
                                                                do
                                                                        let q = "DELETE FROM user_blog WHERE id_user = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        case result of
                                                                                0        ->  do
                                                                                                Log.logIn Log.Error $ "Error remove user" ++ errorText DataErrorPostgreSQL
                                                                                                return $ Left DataErrorPostgreSQL
                                                                                1        ->  do
                                                                                                Log.logIn Log.Debug "remove user good!"  -- log
                                                                                                return $ Right () 
                                                        else
                                                                do
                                                                        Log.logIn Log.Error $ "Error remove user" ++ errorText AccessErrorAdmin
                                                                        return $ Left AccessErrorAdmin
                                                Left err -> do
                                                                Log.logIn Log.Error $ "Error remove user" ++ errorText UserErrorFindBySession
                                                                return $ Left UserErrorFindBySession
                               
                        | text == "author" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                        if authAdmin user then
                                                                do
                                                                        let q = "DELETE FROM author WHERE id_author = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        case result of
                                                                                0        ->  do
                                                                                                Log.logIn Log.Error $ "Error remove author" ++ errorText DataErrorPostgreSQL
                                                                                                return $ Left DataErrorPostgreSQL
                                                                                1        ->  do
                                                                                                Log.logIn Log.Debug "remove author good!"  -- log
                                                                                                return $ Right () 
                                                        else 
                                                                do
                                                                Log.logIn Log.Error $ "Error remove author" ++ errorText AccessErrorAdmin
                                                                return $ Left AccessErrorAdmin
                                                Left err -> do
                                                        Log.logIn Log.Error $ "Error remove author" ++ errorText UserErrorFindBySession
                                                        return $ Left UserErrorFindBySession

                               
                        | text == "category1" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                        if authAdmin user then
                                                                do
                                                                        let q = "DELETE FROM category_1 WHERE id_c1 = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        case result of
                                                                            0        ->  do
                                                                                        Log.logIn Log.Error $ "Error remove category1" ++ errorText DataErrorPostgreSQL
                                                                                        return $ Left DataErrorPostgreSQL
                                                                            1        ->  do
                                                                                        Log.logIn Log.Debug  "remove category1 good!"  -- log
                                                                                        return $ Right ()
                                                        else    
                                                                do
                                                                Log.logIn Log.Error $ "Error remove category1" ++ errorText AccessErrorAdmin
                                                                return $ Left AccessErrorAdmin
                                                Left err -> do
                                                        Log.logIn Log.Error $ "Error remove category1" ++ errorText UserErrorFindBySession
                                                        return $ Left UserErrorFindBySession
                                 
                        | text == "category2" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                        if authAdmin user then
                                                                do
                                                                        let q = " DELETE FROM category_2 WHERE id_c2 = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        print result
                                                                        case result of
                                                                            0        ->  do
                                                                                        Log.logIn Log.Error $ "Error remove category2" ++ errorText DataErrorPostgreSQL
                                                                                        return $ Left DataErrorPostgreSQL
                                                                            1        ->  do
                                                                                        Log.logIn Log.Debug "remove category2 good!"  -- log
                                                                                        return $ Right ()
                                                        else
                                                                do
                                                                Log.logIn Log.Error $ "Error remove category2" ++ errorText AccessErrorAdmin
                                                                return $ Left AccessErrorAdmin
                                                Left err -> do
                                                        Log.logIn Log.Error $ "Error remove category2" ++ errorText UserErrorFindBySession
                                                        return $ Left UserErrorFindBySession
                                
                        | text == "category3" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                        if authAdmin user  then
                                                                do
                                                                        let q = "DELETE FROM category_3 WHERE id_c3 = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        case result of
                                                                                0        ->  do
                                                                                                Log.logIn Log.Error $ "Error remove category3" ++ errorText DataErrorPostgreSQL
                                                                                                return $ Left DataErrorPostgreSQL
                                                                                1        ->  do
                                                                                                Log.logIn Log.Debug "remove category3 good!"  -- log
                                                                                                return $ Right () 
                                                        else
                                                                do
                                                                Log.logIn Log.Error $ "Error remove category3" ++ errorText AccessErrorAdmin
                                                                return $ Left AccessErrorAdmin
                                                Left err -> do
                                                        Log.logIn Log.Error $ "Error remove category3" ++ errorText UserErrorFindBySession
                                                        return $ Left UserErrorFindBySession
                                
                        | text == "comment" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                        if authAdmin user then
                                                                do
                                                                        let q = "DELETE FROM comments WHERE (element_comment).id_comments = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        case result of
                                                                                0        ->  do
                                                                                                Log.logIn Log.Error $ "Error remove comment" ++ errorText DataErrorPostgreSQL
                                                                                                return $ Left DataErrorPostgreSQL
                                                                                1        ->  do
                                                                                                Log.logIn Log.Debug "remove comment good!"  -- log
                                                                                                return $ Right () 
                                                        else    
                                                                do
                                                                Log.logIn Log.Error $ "Error remove comment" ++ errorText AccessErrorAdmin
                                                                return $ Left AccessErrorAdmin
                                                Left err -> do
                                                        Log.logIn Log.Error $ "Error remove comment" ++ errorText UserErrorFindBySession
                                                        return $ Left UserErrorFindBySession
                               
                        | text == "draft" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                        if authAuthor user then
                                                                do
                                                                        let q = "DELETE FROM drafts USING news, author WHERE (elements_draft).news_id_draft = news.id_news and author.id_author = news.authors_id and author.id_user = (?) and (elements_draft).id_draft = (?);"
                                                                        result <- withConn $ \conn -> execute conn q (id_user user,idE)
                                                                        case result of
                                                                                0        ->  do
                                                                                                Log.logIn Log.Error $ "Error remove draft" ++ errorText DataErrorPostgreSQL
                                                                                                return $ Left DataErrorPostgreSQL
                                                                                1        ->  do
                                                                                                Log.logIn Log.Debug  "remove draft good!"  -- log
                                                                                                return $ Right () 
                                                        else        
                                                                do
                                                                Log.logIn Log.Error $ "Error remove draft" ++ errorText AccessErrorAdmin
                                                                return $ Left AccessErrorAdmin
                                                Left err -> do
                                                        Log.logIn Log.Error $ "Error remove draft" ++ errorText UserErrorFindBySession
                                                        return $ Left UserErrorFindBySession
                        | text == "news" = do
                                        access <-  findUserBySession sess
                                        case access of
                                                Right user -> do      
                                                        if authAdmin user then
                                                                do
                                                                        let q = "DELETE FROM news WHERE id_news = (?);"
                                                                        result <- withConn $ \conn -> execute conn q [idE]
                                                                        case result of
                                                                                0        ->  do
                                                                                                Log.logIn Log.Error $ "Error remove news" ++ errorText DataErrorPostgreSQL
                                                                                                return $ Left DataErrorPostgreSQL
                                                                                1        ->  do
                                                                                                Log.logIn Log.Debug  "remove news good!"  -- log
                                                                                                return $ Right () 
                                                        else
                                                                do
                                                                Log.logIn Log.Error $ "Error remove news" ++ errorText AccessErrorAdmin
                                                                return $ Left AccessErrorAdmin
                                                Left err -> do
                                                        Log.logIn Log.Error $ "Error remove news" ++ errorText UserErrorFindBySession
                                                        return $ Left UserErrorFindBySession
                                
                                                                    

