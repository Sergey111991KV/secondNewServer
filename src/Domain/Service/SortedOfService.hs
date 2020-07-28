module Domain.Service.SortedOfService where


import Domain.ImportEntity
import Domain.Service.CommonService
 

class  CommonService m  => SortedOfService m  where        --     API новостей должно поддерживать сортировку по:

    sortedNews :: Text -> m [News]
   
