module Adapter.PostgreSQL.FilterService where

import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common
import  Data.Either
import  Control.Monad.Trans
import GHC.Exception.Type
import ClassyPrelude
import Data.Text
import qualified Data.ByteString.Lazy as B



filterOfData        :: PG r m => String -> String -> m (Either Error [News]) -- API новостей  фильтрация по дате
filterOfData time condition = do
        let q = fromString $ (ClassyPrelude.init $ impureNonNull getAllNewsSQLText) ++ " where data_create_n " ++ condition ++ " " ++ time ++ ";"
        result <- (withConn $ \conn -> query_ conn q  :: IO [News])
        return $ case result of
                                [ ]             ->  Left DataErrorPostgreSQL
                                news         ->  Right  news

filterAuthor        :: PG r m => String -> m (Either Error [News])-- API новостей  фильтрация по имени автора
filterAuthor name = do
        let q = fromString $ (ClassyPrelude.init $ impureNonNull getAllNewsSQLText) ++ " where description_author = '" ++ name ++ "';"
        result <- (withConn $ \conn -> query_ conn q  :: IO [News])
        return $ case result of
                                [ ]             ->  Left DataErrorPostgreSQL
                                news         ->  Right  news 

filterCategory      :: PG r m => Int -> m (Either Error [News])-- API новостей  фильтрация по категории по айди
filterCategory cat = do
        let q = fromString $ (ClassyPrelude.init $ impureNonNull getAllNewsSQLText) ++ " where id_c3 = " ++ (show cat) ++ ";"
        result <- (withConn $ \conn -> query_ conn q  :: IO [News])
        return $ case result of
                                [ ]             ->  Left DataErrorPostgreSQL
                                news         ->  Right  news 

filterTeg          :: PG r m => Int -> m (Either Error [News])-- API новостей  фильтрация по тега по айди
filterTeg idT = do
        let q = fromString getAllNewsSQLTextOneTeg
        result <- (withConn $ \conn -> query conn q [idT] :: IO [News]) 
        return $ case result of
                                [ ]             ->  Left DataErrorPostgreSQL
                                news         ->  Right  news 

filterTegs          :: PG r m => [Int] -> Bool -> m (Either Error [News])
filterTegs = undefined 

-- filterName          :: PG r m => Text -> m (Either Error [News]) -- API новостей  фильтрация по название (вхождение подстроки)
-- filterName = undefined 

-- filterContent       :: PG r m => Text -> m (Either Error [News])-- API новостей  фильтрация по название контент (вхождение подстроки)
-- filterContent = undefined 
