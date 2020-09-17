module Adapter.PostgreSQL.CommonService.Update where

import Adapter.PostgreSQL.Common
import ClassyPrelude
import Control.Monad.Trans
import qualified Data.ByteString.Lazy as B
import Data.Either
import Data.Text
import Domain.ImportEntity
import Domain.Service.Auth
import Domain.Service.CommonService
import GHC.Exception.Type
import qualified Logging.ImportLogging as Log

update :: (PG r m, CommonService m) => SessionId -> Int -> m (Either Error ())
update sess idD = do
  access <- findUserBySession sess
  case access of
    Right users -> do
      if authAuthor users
        then do
          draftResult <- getOne sess ("draft" :: Text) idD
          case draftResult of
            Left err -> return $ Left NotResearchDraft
            Right (EntDraft draft) -> do
              newsResult <- getOne sess ("news" :: Text) (news_id_draft draft)
              case newsResult of
                Left err -> do
                  Log.logIn Log.Error $
                    "Error remove category3" ++ errorText DataErrorPostgreSQL
                  return $ Left NotResearchNews
                Right (EntNews news) -> do
                  let newNews =
                        News
                          (id_news news)
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
                  if id_user users == id_user (user $ authors news)
                    then do
                      Log.logIn Log.Debug "update can take "
                      editing sess (EntNews newNews)
                    else do
                      Log.logIn Log.Error $
                        "Error update " ++ errorText DataErrorPostgreSQL
                      return $ Left DataErrorPostgreSQL
        else do
          Log.logIn Log.Error $ "Error update " ++ errorText AccessErrorAuthor
          return $ Left AccessErrorAuthor
    Left err -> do
      Log.logIn Log.Error $ "Error update " ++ errorText UserErrorFindBySession
      return $ Left UserErrorFindBySession
                           