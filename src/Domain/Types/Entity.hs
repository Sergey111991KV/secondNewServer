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

 



data Entity   = 
    EntAuthor   Author   | 
    EntCategory Category   | 
    EntComment  Comment  | 
    EntDraft    Draft    |
    EntNews     News     | 
    EntUser    User    | 
    EntTeg      Teg deriving (Show, Generic) 


class ConvertClas a where
        convertToCategory :: a -> Category
        convertFromCategory :: Category -> a
        convertToCatEntArray :: [a] -> [Category]


instance ConvertClas Category1 where
        convertToCategory a = CatCategory1 a
        convertFromCategory (CatCategory1 a) = a
        convertToCatEntArray [] = []
        convertToCatEntArray (x:xs) = (convertToCategory x) : (convertToCatEntArray xs)

instance ConvertClas Category2 where
        convertToCategory a =  CatCategory2 a
        convertFromCategory (CatCategory2 a) = a
        convertToCatEntArray [] = []
        convertToCatEntArray (x:xs) = (convertToCategory x) : (convertToCatEntArray xs)

instance ConvertClas Category3 where
        convertToCategory a = CatCategory3 a
        convertFromCategory (CatCategory3 a) = a
        convertToCatEntArray  [] = []
        convertToCatEntArray (x:xs) = (convertToCategory x) : (convertToCatEntArray xs)



class ConvertEntity a where
            convertToEntity :: a -> Entity
            convertFromEntity :: Entity -> a
            convertToEntityArray :: [a] -> [Entity]
            convertFromEntityArray  :: [Entity] -> [a]

instance ConvertEntity Author where
            convertToEntity a =  EntAuthor a
            convertFromEntity (EntAuthor a) = a
            convertToEntityArray [] = []
            convertToEntityArray (x:xs) = (convertToEntity x) : (convertToEntityArray xs)
            convertFromEntityArray  [] = []
            convertFromEntityArray (x:xs) = (convertFromEntity x) : (convertFromEntityArray xs)
            


instance ConvertEntity Category where
            convertToEntity a =  EntCategory a
            convertFromEntity (EntCategory a) = a
            convertToEntityArray [] = []
            convertToEntityArray (x:xs) = (convertToEntity x) : (convertToEntityArray xs)




instance ConvertEntity Comment where
            convertToEntity a =  EntComment a
            convertFromEntity (EntComment a) = a
            convertToEntityArray [] = []
            convertToEntityArray (x:xs) = (convertToEntity x) : (convertToEntityArray xs)

instance ConvertEntity Draft where
            convertToEntity a =  EntDraft a
            convertFromEntity (EntDraft a) = a
            convertToEntityArray [] = []
            convertToEntityArray (x:xs) = (convertToEntity x) : (convertToEntityArray xs)

instance ConvertEntity News where
            convertToEntity a =  EntNews a
            convertFromEntity (EntNews a) = a
            convertToEntityArray [] = []
            convertToEntityArray (x:xs) = (convertToEntity x) : (convertToEntityArray xs)

instance ConvertEntity User where
            convertToEntity a =  EntUser a
            convertFromEntity (EntUser a) = a
            convertToEntityArray [] = []
            convertToEntityArray (x:xs) = (convertToEntity x) : (convertToEntityArray xs)

instance ConvertEntity Teg where
            convertToEntity a =  EntTeg a
            convertFromEntity (EntTeg a) = a
            convertToEntityArray [] = []
            convertToEntityArray (x:xs) = (convertToEntity x) : (convertToEntityArray xs)