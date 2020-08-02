module Domain.Types.News where

import Domain.Types.Imports
import Domain.Types.Author
import Domain.Types.Imports
import Domain.Types.Draft
import Domain.Types.Comment 
import Domain.Types.Teg 
import Domain.Types.User
import Domain.Types.Category
import ClassyPrelude
import Database.PostgreSQL.Simple.FromField

import Database.PostgreSQL.Simple.Types 

data News = News {
    id_news               :: Int,
    data_create_news      :: UTCTime,
    authors               :: Author,
    category              :: Category3,
    text_news             :: Text,
    main_photo_url_news   :: Text,
    other_photo_url_news  :: PGArray Text,
    short_name_news       :: Text
    , drafts              :: PGArray Draft,
    comments              :: PGArray Comment,
    tegs                  :: PGArray Teg
    } deriving (Show, Generic)

instance FromRow News where
    fromRow = News <$> field 
                    <*> field 
                    <*> (return Author `ap` field `ap` field `ap` (return User `ap` field `ap` field `ap` field `ap` field `ap` field `ap` field `ap` field `ap` field `ap` field)) 
                    <*> (return Category3 `ap` field `ap` field `ap` (return Category2 `ap` field `ap` field `ap` ( return Category1 `ap` field `ap` field))) 
                    <*> field 
                    <*> field 
                    <*> field 
                    <*> field 
                    <*> field 
                    <*> field 
                    <*> field



instance  ToRow News   
    -- where
    --         toRow news = [
    --                             toField (id_news news), 
    --                             toField (data_create_news news), 
    --                             toField (authors news), 
    --                             toField (category news), 
    --                             toField (main_photo_url_news news),
    --                             toField (other_photo_url_news news), 
    --                             toField (short_name_news news)
    --                         ]
                  
    
instance FromJSON News
instance ToJSON News

instance FromJSON (PGArray Draft)
instance ToJSON (PGArray Draft)
instance ToRow (PGArray Draft)


instance ToField [Draft]

deriving instance Generic (PGArray Draft) => Generic (PGArray Draft)

instance FromJSON (PGArray Comment)
instance ToJSON (PGArray Comment)
instance ToRow (PGArray Comment)
deriving instance Generic (PGArray Comment) => Generic (PGArray Comment)

instance FromJSON (PGArray Teg)
instance ToJSON (PGArray Teg)
instance ToRow (PGArray Teg)
deriving instance Generic (PGArray Teg) => Generic (PGArray Teg)
