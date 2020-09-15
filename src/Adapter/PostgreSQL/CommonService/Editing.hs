module Adapter.PostgreSQL.CommonService.Editing where

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


editing  :: PG r m =>  SessionId -> Entity -> m (Either Error ())
editing sess (EntTeg      teg)                 = do
                access <-  findUserBySession sess
                case access of
                        Right user -> do      
                                if authAdmin user then
                                   do
                                                let q  = "UPDATE tags SET element_tags.name_teg = (?) WHERE (element_tags).id_teg = (?);"
                                                result <- withConn $ \conn -> execute conn q (name_teg teg, id_teg teg)
                                                case result of
                                                        1        ->  do
                                                                Log.logIn Log.Debug $ "editing user teg!"  ++ entityToText  teg-- log
                                                                return $ Right () 
                                                        0        -> do
                                                                Log.logIn Log.Error $ "Error create teg" ++ errorText DataErrorPostgreSQL
                                                                return $ Left DataErrorPostgreSQL
                                else
                                   do
                                        Log.logIn Log.Error $ "Error create teg" ++ errorText AccessErrorAdmin
                                        return $ Left AccessErrorAdmin
                        Left err -> do
                                Log.logIn Log.Error $ "Error create teg" ++ errorText UserErrorFindBySession
                                return $ Left UserErrorFindBySession
       
            
editing sess (EntAuthor      auth)                 = do
                access <-  findUserBySession sess
                case access of
                        Right users -> do      
                                if authAdmin users then
                                   do
                                        let q  = "UPDATE author SET  description_author = (?), id_user = (?)  WHERE id_author = (?) ;"
                                        result <- withConn $ \conn -> execute conn q (description auth, id_user $ user  auth, id_author auth)
                                        case result of
                                                1        ->  do
                                                                Log.logIn Log.Debug $ "editing user author!"  ++ entityToText  auth -- log
                                                                return $ Right () 
                                                0        ->  do
                                                                Log.logIn Log.Error $ "Error create author" ++ errorText DataErrorPostgreSQL
                                                                return $ Left DataErrorPostgreSQL
                                else
                                   do
                                        Log.logIn Log.Error $ "Error create author" ++ errorText AccessErrorAdmin
                                        return $ Left AccessErrorAdmin
                        Left err -> do
                                Log.logIn Log.Error $ "Error create author" ++ errorText UserErrorFindBySession
                                return $ Left UserErrorFindBySession
       

editing sess (EntCategory (CatCategory1 cat1))                 = do
                access <-  findUserBySession sess
                case access of
                        Right user -> do      
                                if authAdmin user then
                                   do
                                        let q  = "UPDATE category_1 SET  description_cat1 = (?)  WHERE id_c1 = (?) ;"
                                        result <- withConn $ \conn -> execute conn q (name_category_1 cat1, id_category_1 cat1)
                                        case result of
                                                1        -> do
                                                        Log.logIn Log.Debug $ "editing user category1!"  ++ entityToText  cat1 -- log
                                                        return $ Right () 
                                                0        -> do
                                                        Log.logIn Log.Error $ "Error create category1" ++ errorText DataErrorPostgreSQL
                                                        return $ Left DataErrorPostgreSQL
                                else 
                                   do
                                        Log.logIn Log.Error $ "Error create category1" ++ errorText AccessErrorAdmin
                                        return $ Left AccessErrorAdmin
                        Left err -> do
                                Log.logIn Log.Error $ "Error create category1" ++ errorText UserErrorFindBySession
                                return $ Left UserErrorFindBySession
       
editing sess (EntCategory (CatCategory2 cat2))                 = do
                access <-  findUserBySession sess
                case access of
                        Right user -> do      
                           if authAdmin user then
                                do
                                        let q  = "UPDATE category_2 SET  description_cat2 = (?)  WHERE id_c2 = (?) ;"
                                        result <- withConn $ \conn -> execute conn q (name_category_2 cat2, id_category_2 cat2)
                                        case result of
                                                1        ->  do
                                                                Log.logIn Log.Debug $ "editing user category2!"  ++ entityToText  cat2 -- log
                                                                return $ Right () 
                                                0        ->  do
                                                                Log.logIn Log.Error $ "Error create category2" ++ errorText DataErrorPostgreSQL
                                                                return $ Left DataErrorPostgreSQL
                           else
                                do
                                        Log.logIn Log.Error $ "Error create category2" ++ errorText AccessErrorAdmin
                                        return $ Left AccessErrorAdmin
                        Left err -> do
                                Log.logIn Log.Error $ "Error create category2" ++ errorText UserErrorFindBySession
                                return $ Left UserErrorFindBySession
       
editing sess (EntCategory (CatCategory3 cat3))                 = do
                access <-  findUserBySession sess
                case access of
                        Right user -> do      
                                if authAdmin user then
                                        do
                                                let q  = "UPDATE category_3 SET  description_cat3 = (?)  WHERE id_c3 = (?) ;"
                                                result <- withConn $ \conn -> execute conn q (name_category_3 cat3, id_category_3 cat3)
                                                case result of
                                                    1        ->  do
                                                                Log.logIn Log.Debug $ "editing user category3!"  ++ entityToText  cat3 -- log
                                                                return $ Right () 
                                                    0        ->  do
                                                                Log.logIn Log.Error $ "Error create category3" ++ errorText DataErrorPostgreSQL
                                                                return $ Left DataErrorPostgreSQL
                                else
                                        do
                                        Log.logIn Log.Error $ "Error create category3" ++ errorText AccessErrorAdmin
                                        return $ Left AccessErrorAdmin
                        Left err -> do
                                Log.logIn Log.Error $ "Error create category3" ++ errorText UserErrorFindBySession
                                return $ Left UserErrorFindBySession
        
editing sess ( EntComment  com )                 = do
                access <-  findUserBySession sess
                case access of
                        Right user -> do 
                                if id_user user ==  toInteger (users_id_comments com) then
                                        do
                                                let q  = "UPDATE comments SET  element_comment.text_comments = (?) \
                                                \ , element_comment.data_create_comments = (?) \
                                                \ , element_comment.news_id_comments = (?) \
                                                \ , element_comment.users_id_comments = (?) \
                                                \    WHERE (element_comment).id_comments = (?)  ;"
                                                result <- withConn $ \conn -> execute conn q 
                                                                 (  text_comments com
                                                                 ,  data_create_comments com
                                                                 ,  news_id_comments com
                                                                 ,  users_id_comments com
                                                                 ,  id_comments com )
                                                case result of
                                                        1        ->  do
                                                                Log.logIn Log.Debug $ "editing user comment!"  ++ entityToText  com -- log
                                                                return $ Right () 
                                                        0        ->  do
                                                                Log.logIn Log.Error $ "Error create comment" ++ errorText DataErrorPostgreSQL
                                                                return $ Left DataErrorPostgreSQL
                                else
                                        do
                                                Log.logIn Log.Error $ "Error create comment" ++ errorText ErrorCommentToUser
                                                return $ Left ErrorCommentToUser
                        Left err -> do
                                Log.logIn Log.Error $ "Error create draft" ++ errorText UserErrorFindBySession
                                return $ Left UserErrorFindBySession       

editing sess (EntDraft    draft )                 = do
                access <-  findUserBySession sess
                case access of
                        Right user -> do      
                                if authAuthor user then
                                        do
                                                let q  =    "UPDATE drafts SET    elements_draft.text_draft = (?) \
                                                \ , elements_draft.data_create_draft = (?) \
                                                \ , elements_draft.news_id_draft = (?) \
                                                \ , elements_draft.main_photo_url = (?) \
                                                \ , elements_draft.other_photo_url = (?) \
                                                \ , elements_draft.short_name = (?) \
                                                \ FROM news , author \
                                                \ WHERE (elements_draft).id_draft = (?)  and \
                                                \ (elements_draft).news_id_draft = news.id_news and author.id_author = news.authors_id and author.id_user = (?);"
                                                result <- withConn $ \conn -> execute conn q    (  text_draft draft
                                                                                                ,  data_create_draft draft
                                                                                                ,  news_id_draft draft
                                                                                                ,  main_photo_url draft
                                                                                                ,  other_photo_url draft
                                                                                                ,  short_name draft
                                                                                                ,  id_draft draft
                                                                                                ,  id_user user )
                                                case result of
                                                        1        ->  do
                                                                Log.logIn Log.Debug $ "editing user draft!"  ++ entityToText  draft -- log
                                                                return $ Right () 
                                                        0        ->  do
                                                                Log.logIn Log.Error $ "Error create draft" ++ errorText DataErrorPostgreSQL
                                                                return $ Left DataErrorPostgreSQL
                                else    
                                        do
                                        Log.logIn Log.Error $ "Error create draft" ++ errorText AccessErrorAuthor
                                        return $ Left AccessErrorAuthor
                        Left err -> do
                                Log.logIn Log.Error $ "Error create draft" ++ errorText UserErrorFindBySession
                                return $ Left UserErrorFindBySession
        
editing sess ( EntNews     news)                 = do
        
        let q  = "UPDATE news SET       data_create_n = (?) \
                                        \ , authors_id = (?) \
                                        \ , category_3_id = (?) \
                                        \ , description_news = (?) \
                                        \ , main_photo_url_n = (?) \
                                        \ , other_photo_url_n = (?) \
                                        \ , short_name_n = (?) \
                                        \    WHERE id_news = (?)  ;"
        result <- withConn $ \conn -> execute conn q (  
                            data_create_news news
                         ,  id_author $ authors news
                         ,  id_category_3 $ category news
                         ,  text_news news
                         ,  main_photo_url_news news
                         ,  other_photo_url_news news
                         ,  short_name_news news
                         ,  id_news news)
        case result of
            1        ->  do
                        Log.logIn Log.Debug $ "editing user news!"  ++ entityToText  news -- log
                        return $  Right () 
            0        ->  do
                        Log.logIn Log.Error $ "Error create category" ++ errorText DataErrorPostgreSQL
                        return $  Left DataErrorPostgreSQL

editing sess (EntUser    user )                 = do
        access <-  findUserBySession sess
        case access of
                Right user -> do      
                        if authAdmin user then
                                do
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
                                                   nameU user
                                                ,  lastName user
                                                ,  authLogin user
                                                ,  authPassword user
                                                ,  avatar user
                                                ,  dataCreate user
                                                ,  authAdmin user
                                                ,  authAuthor user
                                                ,  id_user user )
                                        case result of
                                                1        ->  do
                                                                Log.logIn Log.Debug $ "editing user user!"  ++ entityToText  user -- log
                                                                return $ Right () 
                                                0        ->  do
                                                                Log.logIn Log.Error $ "Error create user" ++ errorText DataErrorPostgreSQL
                                                                return $ Left DataErrorPostgreSQL
        
                        else
                                do
                                        Log.logIn Log.Error $ "Error create user" ++ errorText AccessErrorAdmin
                                        return $ Left AccessErrorAdmin
                Left err -> do
                        Log.logIn Log.Error $ "Error create user" ++ errorText UserErrorFindBySession
                        return $ Left UserErrorFindBySession
      