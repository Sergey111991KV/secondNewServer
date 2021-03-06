module Adapter.PostgreSQL.CommonService.Сreate where

import Adapter.PostgreSQL.Common
import ClassyPrelude
import Control.Monad.Trans
import qualified Data.ByteString.Lazy as B
import Data.Either
import Data.Text
import Domain.ImportEntity
import Domain.Service.Auth
import GHC.Exception.Type
import qualified Logging.ImportLogging as Log

create :: PG r m => SessionId -> Entity -> m (Either Error ())
create sess (EntAuthor auth) = do
  access <- findUserBySession sess
  case access of
    Right users -> do
      if authAdmin users
        then do
          let q =
                "INSERT INTO author (description_author, id_user_a) VALUES (?,?);"
          result <-
            withConn $ \conn ->
              execute conn q (description auth, id_user $ user auth)
          case result of
            1 -> do
              Log.logIn Log.Debug $ "create author good!" ++ entityToText auth -- log
              return $ Right ()
            0 -> do
              Log.logIn Log.Error $
                "Error create author " ++ errorText DataErrorPostgreSQL
              return $ Left DataErrorPostgreSQL
        else return $ Left AccessErrorAdmin
    Left err -> return $ Left UserErrorFindBySession
create sess (EntUser us) = do
  access <- findUserBySession sess
  case access of
    Right user -> do
      if authAdmin user
        then do
          let q =
                "INSERT INTO user_blog (name_user, last_name_user, login, password  \
                                                \ , avatar, data_create_u, admini, author) VALUES (?,?,?,?,?,?,?,?);"
          result <-
            withConn $ \conn ->
              execute
                conn
                q
                ( nameU us
                , lastName us
                , authLogin us
                , authPassword us
                , avatar us
                , dataCreate us
                , authAdmin us
                , authAuthor us)
                                                -- `catch` \(e :: SqlError) -> do
                                                        -- return 2  -- exeption))
          case result of
            1 -> do
              Log.logIn Log.Debug $ "create user user!" ++ entityToText us -- log
              return $ Right ()
            0 -> do
              Log.logIn Log.Error $
                "Error create user" ++ errorText DataErrorPostgreSQL
              return $ Left DataErrorPostgreSQL
        else return $ Left AccessErrorAdmin
    Left err -> return $ Left UserErrorFindBySession
create sess (EntCategory (CatCategory1 cat)) = do
  access <- findUserBySession sess
  case access of
    Right user -> do
      if authAdmin user
        then do
          let q = "INSERT INTO category_1 (description_cat1) VALUES (?);"
          result <- withConn $ \conn -> execute conn q [name_category_1 cat]
          case result of
            1 -> do
              Log.logIn Log.Debug $ "create user category!" ++ entityToText cat -- log
              return $ Right ()
            0 -> do
              Log.logIn Log.Error $
                "Error create category" ++ errorText UserErrorFindBySession
              return $ Left DataErrorPostgreSQL
        else do
          Log.logIn Log.Error $
            "Error create category" ++ errorText UserErrorFindBySession
          return $ Left AccessErrorAdmin
    Left err -> do
      Log.logIn Log.Error $
        "Error create category" ++ errorText UserErrorFindBySession
      return $ Left UserErrorFindBySession
create sess (EntCategory (CatCategory2 cat)) = do
  access <- findUserBySession sess
  case access of
    Right user -> do
      if authAdmin user
        then do
          let q =
                "INSERT INTO category_2 (description_cat2, category_1_id) VALUES (?,?);"
          result <-
            withConn $ \conn ->
              execute
                conn
                q
                (name_category_2 cat, id_category_1 $ category1 cat)
          case result of
            1 -> do
              Log.logIn Log.Debug $ "create user category!" ++ entityToText cat -- log
              return $ Right ()
            0 -> do
              Log.logIn Log.Error $
                "Error create category" ++ errorText UserErrorFindBySession
              return $ Left DataErrorPostgreSQL
        else do
          Log.logIn Log.Error $
            "Error create category" ++ errorText AccessErrorAdmin
          return $ Left AccessErrorAdmin
    Left err -> do
      Log.logIn Log.Error $
        "Error create category" ++ errorText UserErrorFindBySession
      return $ Left UserErrorFindBySession
create sess (EntCategory (CatCategory3 cat)) = do
  access <- findUserBySession sess
  case access of
    Right user -> do
      if authAdmin user
        then do
          let q =
                "INSERT INTO category_3 (description_cat3, category_2_id) VALUES (?,?);"
          result <-
            withConn $ \conn ->
              execute
                conn
                q
                (name_category_3 cat, id_category_2 $ category2 cat)
          case result of
            1 -> do
              Log.logIn Log.Debug $ "create user category!" ++ entityToText cat -- log
              return $ Right ()
            0 -> do
              Log.logIn Log.Error $
                "Error create category" ++ errorText UserErrorFindBySession
              return $ Left DataErrorPostgreSQL
        else do
          Log.logIn Log.Error $
            "Error create category" ++ errorText UserErrorFindBySession
          return $ Left AccessErrorAdmin
    Left err -> do
      Log.logIn Log.Error $
        "Error create category" ++ errorText UserErrorFindBySession
      return $ Left UserErrorFindBySession
                                        -- ////////////
create sess (EntComment com) = do
  access <- findUserBySession sess
  case access of
    Right user -> do
      let q = "INSERT INTO comments (element_comment) VALUES((?,?,?,?,?));"
      result <- withConn $ \conn -> execute conn q com
      return $
        case result of
          1 -> Right ()
          0 -> Left DataErrorPostgreSQL
    Left err -> do
      Log.logIn Log.Error $
        "Error create category" ++ errorText UserErrorFindBySession
      return $ Left UserErrorFindBySession
create sess (EntDraft draft) = do
  access <- findUserBySession sess
  case access of
    Right user -> do
      if authAuthor user
        then do
          let q = "INSERT INTO drafts (elements_draft) VALUES((?,?,?,?,?,?,?));"
          result <- withConn $ \conn -> execute conn q draft
          case result of
            1 -> do
              Log.logIn Log.Debug $ "create draft!" ++ entityToText draft -- log
              return $ Right ()
            0 -> do
              Log.logIn Log.Error $
                "Error create draft" ++ errorText UserErrorFindBySession
              return $ Left DataErrorPostgreSQL
        else do
          Log.logIn Log.Error $
            "Error create draft" ++ errorText AccessErrorAuthor
          return $ Left AccessErrorAuthor
    Left err -> do
      Log.logIn Log.Error $
        "Error create draft" ++ errorText UserErrorFindBySession
      return $ Left UserErrorFindBySession
create sess (EntTeg teg) = do
  access <- findUserBySession sess
  case access of
    Right user -> do
      if authAdmin user
        then do
          let q = "INSERT INTO tags (element_tags) VALUES((?,?));"
          result <- withConn $ \conn -> execute conn q teg
          case result of
            1 -> do
              Log.logIn Log.Debug $ "create teg!" ++ entityToText teg -- log
              return $ Right ()
            0 -> do
              Log.logIn Log.Error $
                "Error create teg" ++ errorText UserErrorFindBySession
              return $ Left DataErrorPostgreSQL
        else do
          Log.logIn Log.Error $
            "Error create teg" ++ errorText UserErrorFindBySession
          return $ Left AccessErrorAdmin
    Left err -> do
      Log.logIn Log.Error $
        "Error create teg" ++ errorText UserErrorFindBySession
      return $ Left UserErrorFindBySession
create sess (EntNews news) = do
  access <- findUserBySession sess
  case access of
    Right user -> do
      if authAuthor user
        then do
          let q = "INSERT INTO news (data_create_n, authors_id, category_3_id, description_news,  \
                  \ main_photo_url_n, other_photo_url_n, short_name_n) VALUES (?,?,?,?,?,?,?);"
          result <-
            withConn $ \conn ->
              execute
                conn
                q
                ( data_create_news news
                , id_author $ authors news
                , id_category_3 $ category news
                , text_news news
                , main_photo_url_news news
                , other_photo_url_news news
                , short_name_news news)
          case result of
            1 -> do
              Log.logIn Log.Debug $ "create news!" ++ entityToText news
              return $ Right ()
            0 -> do
              Log.logIn Log.Error $
                "Error create news" ++ errorText DataErrorPostgreSQL
              return $ Left DataErrorPostgreSQL
        else do
          Log.logIn Log.Error $
            "Error create news" ++ errorText AccessErrorAuthor
          return $ Left AccessErrorAuthor
    Left err -> do
      Log.logIn Log.Error $
        "Error create news" ++ errorText UserErrorFindBySession
      return $ Left UserErrorFindBySession
