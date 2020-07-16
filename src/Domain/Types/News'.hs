module Domain.Types.News' where

import Domain.Types.Imports
import Database.PostgreSQL.Simple.Types 

data News' = News' {
    id_news'               :: Int,
    data_create_news'      :: UTCTime,
    authors_id_news'       :: Int,
    category_3_id_news'    :: Int,
    text_news'             :: Text,
    main_photo_url_news'   :: Text,
    other_photo_url_news'  :: PGArray Text,
    short_name_news'       :: Text
    } deriving (Eq, Ord, Show, Read, Generic)

instance FromRow News' where
instance  ToRow News' where
  