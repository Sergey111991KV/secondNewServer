module Domain.Types.User where

import ClassyPrelude
import Database.PostgreSQL.Simple.FromField
import Domain.Types.Imports

data User =
  User
    { id_user :: Integer
    , nameU :: Text
    , lastName :: Text
    , authLogin :: Text
    , authPassword :: Text
    , avatar :: Text
    , dataCreate :: UTCTime
    , authAdmin :: Bool
    , authAuthor :: Bool
    }
  deriving (Show, Eq, Generic)

instance FromJSON User

instance ToJSON User

instance FromField User where
  fromField u = fromJSONField u

instance ToField User where
  toField u = toJSONField u

instance FromRow User where
  fromRow =
    User <$> field <*> field <*> field <*> field <*> field <*> field <*> field <*>
    field <*>
    field

instance ToRow User
--  where
--     toRow u = [ toField (id_user u)
--               , toField (nameU u)
--               , toField (lastName u)
--               , toField (authLogin u)
--               , toField (authPassword u)
--               , toField (avatar u)
--               , toField (dataCreate u)
--               , toField (authAdmin u)
--               , toField (authAuthor u)
--               ]
-- instance ToField User where
--     toField User{..} = Many [ Plain "row("
--     , Escape (encodeUtf8 addressStreet)
--     , Plain ","
--     , maybe (Plain "null") (Escape . encodeUtf8) addressStreet2
--     , Plain ","
--     , Escape (encodeUtf8 addressCity)
--     , Plain ","
--     , Escape (encodeUtf8 addressState)
--     , Plain ","
--     , Escape (encodeUtf8 addressPostCode)
--     , Plain ")"
--     ]
--     instance ToField UTCTime where
--         toField = Plain . inQuotes . utcTimeToBuilder
