module Domain.Types.Category where

import Domain.Types.Imports
import Control.Applicative 
import Control.Monad
import Database.PostgreSQL.Simple.FromField 
import ClassyPrelude


data  Category1 = Category1 
        { id_category_1             :: Int
        , name_category_1           :: String
        } deriving (Show, Eq, Generic)

instance FromRow Category1 where
  fromRow = Category1 <$> field <*> field
  -- return Category2 `ap` field `ap` field `ap` return Category3 `ap` field `ap` field

instance  ToRow Category1

instance FromField Category1 where
  fromField = fromJSONField 
instance ToField Category1 where
  toField = toJSONField 

instance ToJSON Category1
instance  FromJSON Category1


data  Category2 = Category2
        { id_category_2             :: Int
        , name_category_2           :: String
        , category1                 :: Category1
        } deriving (Show, Eq, Generic)

        
instance FromRow Category2 where
  fromRow = Category2 <$> field <*> field <*>  return Category1 `ap` field `ap` field

instance  ToRow Category2

instance FromField Category2 where
  fromField = fromJSONField 
instance ToField Category2 where
  toField = toJSONField 

instance ToJSON Category2
instance  FromJSON Category2   
 

data  Category3 = Category3
        { id_category_3            :: Int
        , name_category_3          :: String
        , category2                :: Category2
        } deriving (Show, Eq, Generic)


instance FromRow Category3 where
  fromRow = Category3 <$> field <*> field <*> return Category2 `ap` field `ap` field `ap` ( return Category1 `ap` field `ap` field)

instance  ToRow Category3


instance FromField Category3 where
  fromField = fromJSONField 
instance ToField Category3 where
  toField = toJSONField 

instance ToJSON Category3
instance  FromJSON Category3


data Category = CatCategory1 Category1 | CatCategory2 Category2 | CatCategory3 Category3 deriving (Show, Eq, Generic)

instance FromJSON Category
instance ToJSON Category


