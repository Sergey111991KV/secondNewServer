module Domain.Service.SortedOfService where


import Domain.ImportEntity
import Domain.Service.CommonService
 

class  CommonService m  => SortedOfService m  where        --     API новостей должно поддерживать сортировку по:
    sortedDate      :: Day -> m [a]           -- дате,
    sortedAuthor    :: Author -> m [a]        -- автору (имя по алфавиту),
    sortedCategory  :: [a] -> m [a] -- по категориям (название по алфавиту), 
    sortedPhoto     :: [a] -> m [a] -- по количеству фотографий
