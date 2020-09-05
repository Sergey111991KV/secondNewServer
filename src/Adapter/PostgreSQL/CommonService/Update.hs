module Adapter.PostgreSQL.CommonService.Update where

import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common
import  Data.Either
import  Control.Monad.Trans
import GHC.Exception.Type
import ClassyPrelude
import Data.Text
import qualified Data.ByteString.Lazy as B
import Domain.Service.Auth 
import Domain.Service.CommonService 
import qualified Logging.ImportLogging as Log

update  :: (PG r m, CommonService m) => SessionId -> Int  -> m (Either Error ())
update sess idD  = do
        access <-  findUserBySession sess
        case access of
            Right users -> do      
                case (authAuthor users) of
                    True -> do
                            draftResult <- getOne  sess  ("draft" :: Text) idD 
                            case draftResult of
                                Left err -> return $ Left NotResearchDraft
                                Right (EntDraft draft)  -> do
                                        newsResult <- getOne  sess  ("news" :: Text)  (news_id_draft draft)
                                        case newsResult of
                                                Left err -> do
                                                                Log.logIn Log.Error $ "Error remove category3" ++ (errorText DataErrorPostgreSQL)
                                                                return $ Left NotResearchNews
                                                Right (EntNews news) -> do
                                                        let newNews = News       (id_news news)
                                                                (data_create_draft draft)
                                                                (authors news)
                                                                (category news)
                                                                (ClassyPrelude.pack $ text_draft draft)
                                                                (ClassyPrelude.pack $ main_photo_url draft)
                                                                (other_photo_url draft)
                                                                (ClassyPrelude.pack $ short_name draft)
                                                                (drafts news)
                                                                (comments news)
                                                                (tegs news)
                                                        case (id_user users) == (id_user $ user $ authors news) of
                                                                True  ->  do
                                                                        Log.logIn Log.Debug $ "update can take "  
                                                                        editing sess ( EntNews     newNews) 
                                                                False ->  do
                                                                        Log.logIn Log.Error $ "Error update " ++ (errorText DataErrorPostgreSQL)
                                                                        return $ Left AccessErrorAuthor 
                    False -> do
                                Log.logIn Log.Error $ "Error update " ++ (errorText DataErrorPostgreSQL)
                                return $ Left AccessErrorAuthor
            Left err -> do
                        Log.logIn Log.Error $ "Error update " ++ (errorText DataErrorPostgreSQL)
                        return $ Left UserErrorFindBySession
                                                    
                                    
                                --                 authorResult <-  getOne  sess  ("author" :: Text) idD 
                                --     case authorResult of
                                --         Left err -> return $ Left NotResearchAuthor
                                --         Right (EntAuthor author)  -> do

                                                --  пока превращение черновика в новость не реализовал, так как логику нужно продумать
                                                -- case (news_id_draft draft) of
                                                --         0 -> do
                                                --                 idNews <- getLastIdNews
                                                --                 let n = News idNews (data_create_draft draft) author ?? (text_draft draft)   (main_photo_url draft) (other_photo_url draft) (short_name draft) ?? ?? ?? ??

                                                        -- _ -> do
                                                                -- print "запрос"
                                                                -- print draft 
                                                                -- print 
                                                                -- let q  = "UPDATE news SET       \
                                                                --         \  data_create_n = (?) \
                                                                --         \ , description_news = (?) \
                                                                --         \ , main_photo_url_n = (?) \
                                                                --         \ , other_photo_url_n = (?) \
                                                                --         \ , short_name_n = (?) \
                                                                --         \    WHERE id_news = (?) and authors_id = (?) ;"
                                                                -- result <- withConn $ \conn -> execute conn q    ( (data_create_draft draft)
                                                                --         , (text_draft draft)  
                                                                --         ,  (main_photo_url draft)
                                                                --         ,  (other_photo_url draft)
                                                                --         ,  (short_name draft)
                                                                --         ,  (news_id_draft draft)
                                                                --         ,  (id_author author))
                                                                --         -- data_create_n = (?) \
                                                                --         -- \ , authors_id = (?) \
                                                                --         -- \ , category_3_id = (?) \
                                                                --         -- \ , description_news = (?) \
                                                                --         -- \ , main_photo_url_n = (?) \
                                                                --         -- \ , other_photo_url_n = (?) \
                                                                --         -- \ , short_name_n = (?) \
                                                                -- return $ case result of
                                                                --         1        ->  Right () 
                                                                --         0        ->  Left AccessErrorAuthor
        

-- getLastIdNews :: (PG r m, CommonService m) => m Int
-- getLastIdNews = undefined