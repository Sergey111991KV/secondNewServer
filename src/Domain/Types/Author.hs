module Domain.Types.Author where

import ClassyPrelude
import Control.Applicative
import Control.Monad
import Database.PostgreSQL.Simple.FromField
import Domain.Types.Imports
import Domain.Types.User

data Author =
  Author
    { id_author :: Integer
    , description :: String
    , user :: User
    }
  deriving (Show, Generic)

instance FromJSON Author

instance ToJSON Author

instance FromRow Author where
  fromRow =
    Author <$> field <*> field <*>
    return User `ap` field `ap` field `ap` field `ap` field `ap` field `ap`
    field `ap`
    field `ap`
    field `ap`
    field

instance ToRow Author where
  toRow auth =
    [toField (id_author auth), toField (description auth), toField (user auth)]

instance FromField Author where
  fromField = fromJSONField

instance ToField Author where
  toField = toJSONField
