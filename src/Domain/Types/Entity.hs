module Domain.Types.Entity where

import Domain.Types.Imports
import Domain.Types.Author     
import Domain.Types.Category  
import Domain.Types.Comment  
import Domain.Types.Draft     
import Domain.Types.News      
import Domain.Types.Teg 
import Domain.Types.User       


 

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
