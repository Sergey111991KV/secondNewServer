module Domain.Types.News where

import Domain.Types.Imports
import Domain.Types.Author
import Domain.Types.Imports
import Domain.Types.Draft
import Domain.Types.Comment 
import Domain.Types.Teg 
import Domain.Types.Category

import Database.PostgreSQL.Simple.Types 

data News = News {
    id_news               :: Int,
    data_create_news      :: UTCTime,
    authors               :: Author,
    category              :: Category1,
    text_news             :: Text,
    main_photo_url_news   :: Text,
    other_photo_url_news  :: PGArray Text,
    short_name_news       :: Text,
    drafts                :: [Draft]
    } deriving (Show, Eq, Generic)
             
    
instance FromJSON News
instance ToJSON News

instance FromJSON (PGArray Text)
instance ToJSON (PGArray Text)
deriving instance Generic (PGArray Text) => Generic (PGArray Text)