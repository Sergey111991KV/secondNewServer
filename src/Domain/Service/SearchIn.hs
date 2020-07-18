module Domain.Service.SearchIn where


import Domain.ImportEntity
import Domain.Service.CommonService 
import ClassyPrelude


class CommonService m  => SearchIn m  where
    searchInContent :: Text -> m (Either Error [News] )   -- API новостей должно поддерживать поиск по строке, которая может быть найдена либо в текстовом контенте,
    searchInEntyty  :: Text -> m (Either Error [News] )    --  либо в имени автора, либо в названии категории/тега
