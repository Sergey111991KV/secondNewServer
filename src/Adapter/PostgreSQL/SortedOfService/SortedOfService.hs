module Adapter.PostgreSQL.SortedOfService.SortedOfService where

import Adapter.PostgreSQL.Common
import ClassyPrelude
import Control.Monad.Trans
import qualified Data.ByteString.Lazy as B
import Data.Either
import Data.Text
import Domain.ImportEntity
import GHC.Exception.Type

sortedNews :: PG r m => Text -> m [News]
sortedNews txt
  | txt == "date" = sortedDate
  | txt == "author" = sortedAuthor
  | txt == "category" = sortedCategory
  | txt == "photo" = sortedPhoto

sortedDate :: PG r m => m [News] -- дате,
sortedDate = do
  let q =
        fromString $
        ClassyPrelude.init (impureNonNull getAllNewsSQLText) ++
        " ORDER BY data_create_n;"
  withConn $ \conn -> query_ conn q :: IO [News]

sortedAuthor :: PG r m => m [News] -- автору (имя по алфавиту),
sortedAuthor = do
  let q =
        fromString $
        ClassyPrelude.init (impureNonNull getAllNewsSQLText) ++
        " ORDER BY description_author;"
  withConn $ \conn -> query_ conn q :: IO [News]

sortedCategory :: PG r m => m [News] -- по категориям (название по алфавиту), 
sortedCategory = do
  let q =
        fromString $
        ClassyPrelude.init (impureNonNull getAllNewsSQLText) ++
        " ORDER BY description_cat3;"
  withConn $ \conn -> query_ conn q :: IO [News]

sortedPhoto :: PG r m => m [News] -- по количеству фотографий
sortedPhoto = do
  let q =
        fromString $
        ClassyPrelude.init (impureNonNull getAllNewsSQLText) ++
        " ORDER BY other_photo_url_n;"
  withConn $ \conn -> query_ conn q :: IO [News]
--  Здесь можно еще добавить в запрос к базе DESC или ASC - это или ввести новую переменную(что предпочтительнее - так как нельзя 
-- будет ошибиться) или добавить еще варианты txt - тут опять же плохая масштабируемость, но в задании не говорили конкретно как 
-- сортировать)
