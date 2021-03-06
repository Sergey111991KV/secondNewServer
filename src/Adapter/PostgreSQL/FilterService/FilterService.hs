module Adapter.PostgreSQL.FilterService.FilterService where

import Adapter.PostgreSQL.Common
import ClassyPrelude
import Control.Monad.Trans
import qualified Data.ByteString.Lazy as B
import Data.Either
import Data.Text
import Domain.ImportEntity
import GHC.Exception.Type
import qualified Logging.ImportLogging as Log
import qualified Prelude

filterOfData :: PG r m => String -> String -> m (Either Error [News]) -- API новостей  фильтрация по дате
filterOfData time condition = do
  let q =
        fromString $
        ClassyPrelude.init (impureNonNull getAllNewsSQLText) ++
        " where data_create_n " ++ condition ++ " " ++ time ++ ";"
  result <- withConn $ \conn -> query_ conn q :: IO [News]
  case result of
    [] -> do
      Log.logIn Log.Error $
        "Error filterOfData " ++ errorText DataErrorPostgreSQL
      return $ Left DataErrorPostgreSQL
    news -> do
      Log.logIn Log.Debug "filterOfData good! "
      return $ Right news

filterAuthor :: PG r m => String -> m (Either Error [News]) -- API новостей  фильтрация по имени автора
filterAuthor name = do
  let q =
        fromString $
        ClassyPrelude.init (impureNonNull getAllNewsSQLText) ++
        " where description_author = '" ++ name ++ "';"
  result <- withConn $ \conn -> query_ conn q :: IO [News]
  case result of
    [] -> do
      Log.logIn Log.Error $
        "Error filterAuthor " ++ errorText DataErrorPostgreSQL
      return $ Left DataErrorPostgreSQL
    news -> do
      Log.logIn Log.Debug "filterAuthor good! "
      return $ Right news

filterCategory :: PG r m => Int -> m (Either Error [News]) -- API новостей  фильтрация по категории по айди
filterCategory cat = do
  let q =
        fromString $
        ClassyPrelude.init (impureNonNull getAllNewsSQLText) ++
        " where id_c3 = " ++ show cat ++ ";"
  result <- withConn $ \conn -> query_ conn q :: IO [News]
  case result of
    [] -> do
      Log.logIn Log.Error $
        "Error filterCategory " ++ errorText DataErrorPostgreSQL
      return $ Left DataErrorPostgreSQL
    news -> do
      Log.logIn Log.Debug "filterCategory good! "
      return $ Right news

filterTeg :: PG r m => Int -> m (Either Error [News]) -- API новостей  фильтрация по тега по айди
filterTeg idT = do
  let q = fromString (getAllNewsSQLTextTeg ++ "where n.tags_id = (?);")
  result <- withConn $ \conn -> query conn q [idT] :: IO [News]
  case result of
    [] -> do
      Log.logIn Log.Error $ "Error filterTeg " ++ errorText DataErrorPostgreSQL
      return $ Left DataErrorPostgreSQL
    news -> do
      Log.logIn Log.Debug "filterTeg good! "
      return $ Right news

filterOneOfTegs :: PG r m => [Int] -> m (Either Error [News])
filterOneOfTegs idTarray = do
  let q = fromString (getAllNewsSQLTextTeg ++ "where n.tags_id = ANY in (?);")
  result <-
    withConn $ \conn ->
      query conn q [toStringFromArrayInt idTarray] :: IO [News]
  case result of
    [] -> do
      Log.logIn Log.Error $
        "Error filterOneOfTegs " ++ errorText DataErrorPostgreSQL
      return $ Left DataErrorPostgreSQL
    news -> do
      Log.logIn Log.Debug "filterOneOfTegs good! "
      return $ Right news

filterAllOfTegs :: PG r m => [Int] -> m (Either Error [News])
filterAllOfTegs idTarray = do
  let q = fromString (getAllNewsSQLTextTeg ++ "where n.tags_id = all in (?);")
  result <-
    withConn $ \conn ->
      query conn q [toStringFromArrayInt idTarray] :: IO [News]
  case result of
    [] -> do
      Log.logIn Log.Error $
        "Error filterAllOfTegs " ++ errorText DataErrorPostgreSQL
      return $ Left DataErrorPostgreSQL
    news -> do
      Log.logIn Log.Debug "filterAllOfTegs good! "
      return $ Right news

filterName :: PG r m => String -> m (Either Error [News]) -- API новостей  фильтрация по название (вхождение подстроки)
filterName txt = do
  let q =
        fromString $
        ClassyPrelude.init (impureNonNull getAllNewsSQLText) ++
        " where short_name_n LIKE '%" ++ txt ++ "%';"
  result <- withConn $ \conn -> query_ conn q :: IO [News]
  case result of
    [] -> do
      Log.logIn Log.Error $ "Error filterName " ++ errorText DataErrorPostgreSQL
      return $ Left DataErrorPostgreSQL
    news -> do
      Log.logIn Log.Debug "filterName good! "
      return $ Right news

filterContent :: PG r m => String -> m (Either Error [News]) -- API новостей  фильтрация по название контент (вхождение подстроки)
filterContent txt = do
  let q =
        fromString $
        ClassyPrelude.init (impureNonNull getAllNewsSQLText) ++
        " where description_news LIKE '%" ++ txt ++ "%';"
  result <- withConn $ \conn -> query_ conn q :: IO [News]
  case result of
    [] -> do
      Log.logIn Log.Error $
        "Error filterContent " ++ errorText DataErrorPostgreSQL
      return $ Left DataErrorPostgreSQL
    news -> do
      Log.logIn Log.Debug "filterContent good! "
      return $ Right news

-- -- 
toStringFromArrayInt :: [Int] -> String
toStringFromArrayInt array = "{" ++ Prelude.foldl addParam "" array ++ "}"
  where
    addParam [] elem = show elem
    addParam elements elem = elements ++ (',' : show elem)
-- toStringFromArrayInt :: [Int] -> String
-- toStringFromArrayInt array = "(" ++ (Prelude.foldl addParam "" array) ++ ")" 
--         where
--                 addParam [] elem = show elem
--                 addParam elements elem = elements ++ (',' : show elem)
-- filterTegs          :: PG r m => [Int]  -> m (Either Error [News])
-- filterTegs idTarray = do
--         let q = fromString (getAllNewsSQLTextTeg ++ "where n.tags_id in (?);")
--         result <- (withConn $ \conn -> query conn q [toStringFromArrayInt $ idTarray] :: IO [News]) 
--         return $ case result of
--                                 [ ]             ->  Left DataErrorPostgreSQL
--                                 news            ->  Right  news 
