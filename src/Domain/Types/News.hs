module Domain.Types.News where

import ClassyPrelude
import Database.PostgreSQL.Simple.FromField
import Domain.Types.Author
import Domain.Types.Category
import Domain.Types.Comment
import Domain.Types.Draft
import Domain.Types.Imports
import Domain.Types.Teg
import Domain.Types.User

import Database.PostgreSQL.Simple.Types

data News =
  News
    { id_news :: Int
    , data_create_news :: UTCTime
    , authors :: Author
    , category :: Category3
    , text_news :: Text
    , main_photo_url_news :: Text
    , other_photo_url_news :: PGArray Text
    , short_name_news :: Text
    , drafts :: PGArray Draft
    , comments :: PGArray Comment
    , tegs :: PGArray Teg
    }
  deriving (Show, Generic)

instance FromRow News where
  fromRow =
    News <$> field <*> field <*>
    (return Author `ap` field `ap` field `ap`
     (return User `ap` field `ap` field `ap` field `ap` field `ap` field `ap`
      field `ap`
      field `ap`
      field `ap`
      field)) <*>
    (return Category3 `ap` field `ap` field `ap`
     (return Category2 `ap` field `ap` field `ap`
      (return Category1 `ap` field `ap` field))) <*>
    field <*>
    field <*>
    field <*>
    field <*>
    field <*>
    field <*>
    field

instance ToRow News
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
