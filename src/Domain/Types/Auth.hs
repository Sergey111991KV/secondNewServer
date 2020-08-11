module Domain.Types.Auth where

import ClassyPrelude
import Domain.Types.Imports

import Database.PostgreSQL.Simple.FromField 




newtype SessionId = SessionId { sessionRaw :: Text } deriving (Generic, Show, Eq, Ord)
rawSession :: SessionId -> Text
rawSession = sessionRaw
instance FromField SessionId where
  fromField field mb_bytestring = SessionId <$> fromField field mb_bytestring
instance FromRow SessionId where
  fromRow = SessionId <$> field
instance FromJSON SessionId
instance ToJSON SessionId
instance  ToRow SessionId
instance ToField SessionId where
  toField ip = toField $ sessionRaw ip


newtype UserId = UserId {rawUserId :: Int} deriving (Generic, Show, Eq, Ord)

instance FromField UserId where
  fromField field mb_bytestring = UserId <$> fromField field mb_bytestring
instance FromRow UserId where
  fromRow = UserId <$> field

instance FromJSON UserId
instance ToJSON UserId
instance  ToRow UserId

instance ToField UserId where
  toField ip = toField $ rawUserId ip