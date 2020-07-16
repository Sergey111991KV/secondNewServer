module Domain.Types.Author where

import Domain.Types.User
import Domain.Types.Imports


data Author = Author {
    id_author          :: Int,
    description        :: String,
    user               :: User
    } deriving (Show, Eq, Generic)

instance FromJSON Author
instance ToJSON Author
