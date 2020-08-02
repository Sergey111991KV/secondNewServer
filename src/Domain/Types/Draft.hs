module Domain.Types.Draft where

import Domain.Types.Imports
import Database.PostgreSQL.Simple.FromField 
import ClassyPrelude
import Database.PostgreSQL.Simple.Types 
-- import Database.PostgreSQL.Simple.Arrays
import qualified Data.Attoparsec.ByteString.Char8 as A
import           Data.ByteString.Builder
import           Data.ByteString
import Data.ByteString.Internal


data Draft = Draft 
    { id_draft          :: Int
    , text_draft        :: String
    , data_create_draft  :: UTCTime
    -- , data_create_draft :: ZonedTime
    , news_id_draft      :: Int
    , main_photo_url    :: String
    , other_photo_url   :: PGArray Text
    , short_name        :: String
    --  ZonedTime
    } deriving (Show, Generic)

instance FromRow Draft where
    fromRow = Draft <$> field <*> field <*> field <*> field <*> field <*> field <*> field  

instance FromJSON Draft
instance ToJSON Draft
instance  ToRow Draft

instance FromField Draft 

instance ToField Draft where
    toField (Draft idD text dataTime newid mainP othrP sname) = 
        Many [
            Plain "row("
          , Plain (intDec idD)
          , Plain ","
          , Escape (fromString text)
          , Plain ","
          -- , Plain ( utcTimeToBuilder dataTime)
          , Plain ")"
        ]
-- instance ToField Address where
--   toField Address{..} = 
    -- Many [ Plain "row("
    --      , Escape (encodeUtf8 addressStreet)
    --      , Plain ","
    --      , maybe (Plain "null") (Escape . encodeUtf8) addressStreet2
    --      , Plain ","
    --      , Escape (encodeUtf8 addressCity)
    --      , Plain ","
    --      , Escape (encodeUtf8 addressState)
    --      , Plain ","
    --      , Escape (encodeUtf8 addressPostCode)
    --      , Plain ")"
    --      ]


instance FromJSON (PGArray Text)
instance ToJSON (PGArray Text)
deriving instance Generic (PGArray Text) => Generic (PGArray Text)