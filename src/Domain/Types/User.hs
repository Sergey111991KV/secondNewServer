module Domain.Types.User where

import Domain.Types.Imports



data  User = User
  { 
    id_user      :: Integer
  , name         :: Text
  , lastName     :: Text
  , authLogin    :: Text
  , authPassword :: Text
  , avatar       :: Text
  , dataCreate   :: UTCTime
  , authAdmin    :: Bool
  , authAuthor   :: Bool
  } deriving (Show, Eq, Generic)

instance FromRow User where
  fromRow = User <$> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field

instance FromJSON User
instance ToJSON User
instance  ToRow User

