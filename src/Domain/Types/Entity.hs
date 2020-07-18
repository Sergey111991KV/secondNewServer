module Domain.Types.Entity where

import Domain.Types.Imports
import Domain.Types.Author     
import Domain.Types.Category  

import Domain.Types.Comment  
import Domain.Types.Draft     
import Domain.Types.News      
import Domain.Types.Teg 
import Domain.Types.User       
import ClassyPrelude

 

data Category = CatCategory1 Category1 | CatCategory2 Category2 | CatCategory3 Category3 deriving (Show, Eq, Generic)

instance FromJSON Category
instance ToJSON Category


data Entity   = 
    EntAuthor   Author   | 
    EntCategory Category   | 
    EntComment  Comment  | 
    EntDraft    Draft    |
    EntNews     News     | 
    EntUser    User    | 
    EntTeg      Teg deriving (Show, Eq, Generic) 



class ConvertEntity a where
            convertToEntity :: a -> Entity
            convertFromEntity :: Entity -> a

instance ConvertEntity Author where
            convertToEntity a =  EntAuthor a
            convertFromEntity (EntAuthor a) = a

instance ConvertEntity Category where
            convertToEntity a =  EntCategory a
            convertFromEntity (EntCategory a) = a

instance ConvertEntity Comment where
            convertToEntity a =  EntComment a
            convertFromEntity (EntComment a) = a

instance ConvertEntity Draft where
            convertToEntity a =  EntDraft a
            convertFromEntity (EntDraft a) = a

instance ConvertEntity News where
            convertToEntity a =  EntNews a
            convertFromEntity (EntNews a) = a


instance ConvertEntity User where
            convertToEntity a =  EntUser a
            convertFromEntity (EntUser a) = a

instance ConvertEntity Teg where
            convertToEntity a =  EntTeg a
            convertFromEntity (EntTeg a) = a