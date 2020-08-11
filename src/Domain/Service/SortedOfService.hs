module Domain.Service.SortedOfService where


import Domain.ImportEntity
import Domain.Service.CommonService
 

class CommonService m => SortedOfService m  where       
    sortedNews :: Text -> m [News]
   
