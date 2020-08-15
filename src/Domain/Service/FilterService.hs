module Domain.Service.FilterService where


import Domain.ImportEntity
import Domain.Service.CommonService 
import ClassyPrelude


class CommonService m  => FilterService m  where
    filterOfData        :: String -> String -> m (Either Error [News]) -- API новостей  фильтрация по дате
    filterAuthor        :: String -> m (Either Error [News])-- API новостей  фильтрация по имени автора
    filterCategory      :: Int -> m (Either Error [News])-- API новостей  фильтрация по категории по айди
    filterTeg           :: Int -> m (Either Error [News])-- API новостей  фильтрация по тега по айди
    filterOneOfTegs     :: [Int] -> m (Either Error [News])
    filterAllOfTegs     :: [Int] -> m (Either Error [News])
    filterName          :: String -> m (Either Error [News]) -- API новостей  фильтрация по название (вхождение подстроки)
    filterContent       :: String -> m (Either Error [News])-- API новостей  фильтрация по название контент (вхождение подстроки)

