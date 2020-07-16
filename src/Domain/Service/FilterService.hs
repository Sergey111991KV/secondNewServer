module Domain.Service.FilterService where


import Domain.ImportEntity
import Domain.Service.CommonService 


class CommonService m  => FilterService m  where
    filterOfData        :: Text -> m (Either Error [News]) -- API новостей  фильтрация по дате
    filterAuthor        :: Int -> m (Either Error [News])-- API новостей  фильтрация по имени автора
    filterCategory      :: Int -> m (Either Error [News])-- API новостей  фильтрация по категории по айди
    filterTeg           :: Int -> m (Either Error [News])-- API новостей  фильтрация по тега по айди
    filterName          :: Text -> m (Either Error [News]) -- API новостей  фильтрация по название (вхождение подстроки)
    filterContent       :: Text -> m (Either Error [News])-- API новостей  фильтрация по название контент (вхождение подстроки)
