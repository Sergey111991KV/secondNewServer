module Adapter.PostgreSQL.FilterService.FilterService where

import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common
import  Data.Either
import  Control.Monad.Trans
import GHC.Exception.Type
import ClassyPrelude
import Data.Text
import qualified Data.ByteString.Lazy as B
import qualified Prelude as Prelude


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
        let q = fromString (getAllNewsSQLTextTeg ++ "where n.tags_id = (?);")
        result <- (withConn $ \conn -> query conn q [idT] :: IO [News]) 
        return $ case result of
                                [ ]             ->  Left DataErrorPostgreSQL
                                news         ->  Right  news 



filterOneOfTegs          :: PG r m => [Int]  -> m (Either Error [News])
filterOneOfTegs idTarray = do
        let q = fromString (getAllNewsSQLTextTeg ++ "where n.tags_id = ANY in (?);")
        result <- (withConn $ \conn -> query conn q [toStringFromArrayInt $ idTarray] :: IO [News]) 
        return $ case result of
                                [ ]             ->  Left DataErrorPostgreSQL
                                news            ->  Right  news 

filterAllOfTegs          :: PG r m => [Int]  -> m (Either Error [News])
filterAllOfTegs idTarray = do
        let q = fromString (getAllNewsSQLTextTeg ++ "where n.tags_id = all in (?);")
        result <- (withConn $ \conn -> query conn q [toStringFromArrayInt $ idTarray] :: IO [News]) 
        return $ case result of
                                [ ]             ->  Left DataErrorPostgreSQL
                                news            ->  Right  news 



filterName          :: PG r m => String -> m (Either Error [News]) -- API новостей  фильтрация по название (вхождение подстроки)
filterName txt = do
                let q = fromString $ (ClassyPrelude.init $ impureNonNull getAllNewsSQLText) ++ " where short_name_n LIKE '%" ++ txt ++ "%';"
                result <- (withConn $ \conn -> query_ conn q  :: IO [News])
                return $ case result of
                                        [ ]             ->  Left DataErrorPostgreSQL
                                        news         ->  Right  news 
         

filterContent       :: PG r m => String -> m (Either Error [News])-- API новостей  фильтрация по название контент (вхождение подстроки)
filterContent txt = do 
                let q = fromString $ (ClassyPrelude.init $ impureNonNull getAllNewsSQLText) ++ " where description_news LIKE '%" ++ txt ++ "%';"
                result <- (withConn $ \conn -> query_ conn q  :: IO [News])
                return $ case result of
                                        [ ]             ->  Left DataErrorPostgreSQL
                                        news         ->  Right  news 
         
-- -- 

toStringFromArrayInt :: [Int] -> String
toStringFromArrayInt array =  "{" ++ (Prelude.foldl addParam "" array) ++ "}" 
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