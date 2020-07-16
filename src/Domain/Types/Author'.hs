module Domain.Types.Author' where

import Domain.Types.Imports


data Author'  = Author' {
    id_author'          :: Int,
    description' :: String,
    user_id'     :: Int
    } deriving (Show, Eq, Generic)

instance FromRow Author' where
  fromRow = Author' <$> field <*> field <*> field

instance  ToRow Author'
