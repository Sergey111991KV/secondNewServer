module Adapter.PostgreSQL.SortedOfService.SortedOfService where

import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common
import  Data.Either
import  Control.Monad.Trans
import GHC.Exception.Type
import ClassyPrelude
import Data.Text
import qualified Data.ByteString.Lazy as B




sortedNews  :: PG r m => Text ->  m [News] 
sortedNews txt 
                | txt == "date" = sortedDate

                | txt == "author" = sortedAuthor

                | txt == "category" = sortedCategory

                | txt == "photo" = sortedPhoto



sortedDate      :: PG r m =>  m [News]           -- дате,
sortedDate = do
    let q = fromString $ (ClassyPrelude.init $ impureNonNull getAllNewsSQLText) ++ " ORDER BY data_create_n;"
    result <- (withConn $ \conn -> query_ conn q  :: IO [News])
    return  result 



sortedAuthor    :: PG r m =>  m [News]        -- автору (имя по алфавиту),
sortedAuthor = do
        let q = fromString $ (ClassyPrelude.init $ impureNonNull getAllNewsSQLText) ++ " ORDER BY description_author;"
        result <- (withConn $ \conn -> query_ conn q  :: IO [News])
        return  result 


sortedCategory  :: PG r m =>  m [News] -- по категориям (название по алфавиту), 
sortedCategory = do
    let q = fromString $ (ClassyPrelude.init $ impureNonNull getAllNewsSQLText) ++ " ORDER BY description_cat3;"
    result <- (withConn $ \conn -> query_ conn q  :: IO [News])
    return  result 


sortedPhoto     :: PG r m =>  m [News] -- по количеству фотографий
sortedPhoto = do
    let q = fromString $ (ClassyPrelude.init $ impureNonNull getAllNewsSQLText) ++ " ORDER BY other_photo_url_n;"
    result <- (withConn $ \conn -> query_ conn q  :: IO [News])
    return  result 



--  Здесь можно еще добавить в запрос к базе DESC или ASC - это или ввести новую переменную(что предпочтительнее - так как нельзя 
-- будет ошибиться) или добавить еще варианты txt - тут опять же плохая масштабируемость, но в задании не говорили конкретно как 
-- сортировать)