module Domain.Types.Draft where

import Domain.Types.Imports
import Database.PostgreSQL.Simple.FromField 
import ClassyPrelude
import Database.PostgreSQL.Simple.Types 


data Draft = Draft 
    { id_draft          :: Int
    , text_draft        :: String
    , data_create_draft  :: UTCTime
    , news_id_draft      :: Int
    , main_photo_url    :: String
    , other_photo_url   :: PGArray Text
    , short_name        :: String
    --  ZonedTime
    } deriving (Show, Eq, Generic)

instance FromRow Draft where
    fromRow = Draft <$> field <*> field <*> field <*> field <*> field <*> field <*> field  

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

instance FromJSON (PGArray Text)
instance ToJSON (PGArray Text)
deriving instance Generic (PGArray Text) => Generic (PGArray Text)