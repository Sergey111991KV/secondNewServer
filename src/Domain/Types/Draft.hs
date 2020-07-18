module Domain.Types.Draft where

import Domain.Types.Imports
import Database.PostgreSQL.Simple.FromField 
import ClassyPrelude


data Draft = Draft {
    id_draft          :: Int,
    text_draft        :: String,
    news_id_draft      :: Int,
    data_create_draft  :: UTCTime
    --  ZonedTime
    } deriving (Show, Eq, Generic)

instance FromRow Draft where
    fromRow = Draft <$> field <*> field <*> field <*> field 

instance FromJSON Draft
instance ToJSON Draft
instance  ToRow Draft

instance FromField Draft where
  fromField = fromJSONField 
instance ToField Draft where
  toField = toJSONField 
instance FromField [Draft] where
  fromField = fromJSONField 
instance ToField [Draft] where
  toField = toJSONField 