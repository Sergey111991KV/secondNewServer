module Domain.Types.Teg where

import Domain.Types.Imports
import Database.PostgreSQL.Simple.FromField 
import ClassyPrelude

data Teg = Teg {
    id_teg   :: Int,
    name_teg :: String
    } deriving (Show, Eq, Generic)

instance FromRow Teg where
    fromRow = Teg <$> field <*> field 
instance  ToRow Teg
  
instance FromJSON Teg
instance ToJSON Teg

instance FromField Teg where
  fromField = fromJSONField 
instance ToField Teg where
  toField = toJSONField 
instance FromField [Teg] where
  fromField = fromJSONField 
instance ToField [Teg] where
  toField = toJSONField 