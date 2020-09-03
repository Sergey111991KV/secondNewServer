module Adapter.PostgreSQL.CommonService.Сreate where

import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common
import  Data.Either
import  Control.Monad.Trans
import GHC.Exception.Type
import ClassyPrelude
import Data.Text
import qualified Data.ByteString.Lazy as B
import Domain.Service.Auth 
import Logging.ImportLogging



create  :: PG r m => SessionId -> Entity  -> m (Either Error ())
create sess (EntAuthor  auth)  = do
        access <-  findUserBySession sess
        case access of
                        Right users -> do      
                                case (authAdmin users) of
                                        True -> do
                                                let q = "INSERT INTO author (id_author, description_author, id_user) VALUES (?,?,?);"
                                                result <- withConn $ \conn -> execute conn q ((id_author auth), (description auth), (id_user $ user auth) )
                                                return $ case result of
                                                        1        ->  Right () 
                                                        0        ->  Left DataErrorPostgreSQL
                                        False -> return $ Left AccessErrorAdmin
                        Left err -> return $ Left UserErrorFindBySession
       
create sess (EntUser  us)  = do
        access <-  findUserBySession sess
        case access of
                        Right user -> do      
                                case (authAdmin user) of
                                        True -> do
                                                let q = "INSERT INTO user_blog  VALUES (?,?,?,?,?,?,?,?,?);"
                                                result <- withConn $ \conn -> execute conn q us
                                                return $ case result of
                                                        1        ->  Right () 
                                                        0        ->  Left DataErrorPostgreSQL
                                        False -> return $ Left AccessErrorAdmin
                        Left err -> return $ Left UserErrorFindBySession
       
            
create sess (EntCategory (CatCategory1 cat))  = do
        access <-  findUserBySession sess
        case access of
                        Right user -> do      
                                case (authAdmin user) of
                                        True -> do
                                                        let q = "INSERT INTO category_1 (id_c1, description_cat1) VALUES (?,?);"
                                                        result <- withConn $ \conn -> execute conn q (id_category_1 cat, name_category_1 cat )
                                                        return $ case result of
                                                            1        ->  Right () 
                                                            0        ->  Left DataErrorPostgreSQL
                                        False -> return $ Left AccessErrorAdmin
                        Left err -> return $ Left UserErrorFindBySession
      
create sess (EntCategory (CatCategory2 cat))  = do
                access <-  findUserBySession sess
                case access of
                                Right user -> do      
                                        case (authAdmin user) of
                                                True -> do
                                                                let q = "INSERT INTO category_2 (id_c2, description_cat2, category_1_id) VALUES (?,?,?);"
                                                                result <- withConn $ \conn -> execute conn q (id_category_2 cat, name_category_2 cat , (id_category_1 $ category1 cat))
                                                                return $ case result of
                                                                    1        ->  Right () 
                                                                    0        ->  Left DataErrorPostgreSQL
                                                False -> return $ Left AccessErrorAdmin
                                Left err -> return $ Left UserErrorFindBySession

create sess (EntCategory (CatCategory3 cat))  = do
                access <-  findUserBySession sess
                case access of
                                Right user -> do      
                                        case (authAdmin user) of
                                                True -> do
                                                                let q = "INSERT INTO category_3 (id_c3, description_cat3, category_2_id) VALUES (?,?,?);"
                                                                result <- withConn $ \conn -> execute conn q (id_category_3 cat, name_category_3 cat , (id_category_2 $ category2 cat))
                                                                return $ case result of
                                                                    1        ->  Right () 
                                                                    0        ->  Left DataErrorPostgreSQL
                                                False -> return $ Left AccessErrorAdmin
                                Left err -> return $ Left UserErrorFindBySession

create sess (EntComment  com)                 = do
        let q = "INSERT INTO comments (element_comment) VALUES((?,?,?,?,?));"
        result <- withConn $ \conn -> execute conn q com
        return $ case result of
            1        ->  Right () 
            0        ->  Left DataErrorPostgreSQL

create sess (EntDraft    draft)               = do
                access <-  findUserBySession sess
                case access of
                                Right user -> do      
                                        case (authAuthor user) of
                                                True -> do
                                                                let q = "INSERT INTO drafts (elements_draft) VALUES((?,?,?,?,?,?,?));"
                                                                result <- withConn $ \conn -> execute conn q draft
                                                                return $ case result of
                                                                    1        ->  Right () 
                                                                    0        ->  Left DataErrorPostgreSQL
                                                False -> return $ Left AccessErrorAdmin
                                Left err -> return $ Left UserErrorFindBySession

create sess (EntTeg      teg)                 = do
                access <-  findUserBySession sess
                case access of
                                Right user -> do      
                                        case (authAdmin user) of
                                                True -> do
                                                                let q = "INSERT INTO tags (element_tags) VALUES(?);"
                                                                result <- withConn $ \conn -> execute conn q teg
                                                                return $ case result of
                                                                    1        ->  Right () 
                                                                    0        ->  Left DataErrorPostgreSQL
                                                False -> return $ Left AccessErrorAdmin
                                Left err -> return $ Left UserErrorFindBySession
     

create sess (EntNews     news)                = do
                access <-  findUserBySession sess
                case access of
                                Right user -> do      
                                        case (authAuthor user) of
                                                True -> do
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
                                                False -> return $ Left AccessErrorAdmin
                                Left err -> return $ Left UserErrorFindBySession