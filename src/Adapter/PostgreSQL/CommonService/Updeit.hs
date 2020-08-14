module Adapter.PostgreSQL.CommonService.Updeit where

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

updeit  :: (PG r m, CommonService m) => SessionId -> Int  -> m (Either Error ())
updeit sess idD  = do
        access <-  findUserBySession sess
        case access of
            Right users -> do      
                case (authAuthor users) of
                    True -> do
                            draftResult <- getOne  sess  ("draft" :: Text) idD 
                            case draftResult of
                                Left err -> return $ Left NotResearch
                                Right (EntDraft draft)  -> do
                                    authorResult <-  getOne  sess  ("draft" :: Text) idD 
                                    case authorResult of
                                        Left err -> return $ Left NotResearch
                                        Right (EntAuthor author)  -> do
                                                let q  = "UPDATE news SET       \
                                                        \  data_create_n = (?) \
                                                        \ , description_news = (?) \
                                                        \ , main_photo_url_n = (?) \
                                                        \ , other_photo_url_n = (?) \
                                                        \ , short_name_n = (?) \
                                                        \    WHERE id_news = (?) and authors_id = (?) ;"
                                                result <- withConn $ \conn -> execute conn q    ( (data_create_draft draft)
                                                        , (text_draft draft)  
                                                        ,  (main_photo_url draft)
                                                        ,  (other_photo_url draft)
                                                        ,  (short_name draft)
                                                        ,  (news_id_draft draft)
                                                        ,  (id_author author))
                            
                                                return $ case result of
                                                        1        ->  Right () 
                                                        0        ->  Left AccessErrorAuthor
                    False -> return $ Left AccessErrorAdmin
            Left err -> return $ Left UserErrorFindBySession


