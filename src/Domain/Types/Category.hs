module Domain.Types.Category where

import Domain.Types.Imports


data  Category1 = Category1 
        { id_category_1             :: Int
        , name_category_1           :: String
        , category2                :: Category2
        } deriving (Show, Eq, Generic)

instance ToJSON Category1
instance  FromJSON Category1


data  Category2 = Category2
        { id_category_2             :: Int
        , name_category_2           :: String
        , category3                 :: Category3
        } deriving (Show, Eq, Generic)

instance ToJSON Category2
instance  FromJSON Category2   
 

data  Category3 = Category3
        { id_category_3            :: Int
        , name_category_3          :: String
        } deriving (Show, Eq, Generic)


instance ToJSON Category3
instance  FromJSON Category3


