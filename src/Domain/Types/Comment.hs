module Domain.Types.Comment where

import Domain.Types.Imports
import Database.PostgreSQL.Simple.FromField 
import ClassyPrelude
import Database.PostgreSQL.Simple.Types 
import Domain.Parse.ParsePostgresTypes
import qualified Data.Attoparsec.ByteString.Char8 as A
import qualified Data.ByteString.Char8                as B
import qualified Prelude as P
import Data.Time.Format





data Comment = Comment {
    id_comments         :: Int,
    text_comments        :: String,
    data_create_comments :: UTCTime,
    news_id_comments     :: Int,              
    users_id_comments    :: Int
    } deriving (Show, Generic)

instance FromRow Comment 
instance  ToRow Comment
-- where
--     fromRow = Comment <$> field <*> field <*> field <*> field <*> field
instance FromJSON Comment
instance ToJSON Comment


instance FromField Comment where
  fromField = fromPGRow "comment_type" parseComment 
instance ToField Comment where
  toField (Comment idC text dataC newId userId) = 
      Many [
        Plain "row("
      , Plain (intDec idC)
      , Plain ","
      , Escape (fromString text)
      , Plain ","
      , Escape (timeToByteStr dataC)
      , Plain ","
      , Plain (intDec newId)
      , Plain ","
      , Plain (intDec userId)
      , Plain ")"
    ]


parseComment :: A.Parser Comment
parseComment = do
  _ <- A.char '('
  idC <- textContent 
  _ <- A.char ','
  text <-  textContent
  _ <- A.char ','
  dataC <- textContent 
  _ <- A.char ','
  newId <-  textContent
  _ <- A.char ','
  userId <- textContent 
  _ <- A.char ')'
  pure (Comment (P.read $ ClassyPrelude.unpack idC) 
                (ClassyPrelude.unpack text)  
                (timeFromByteString dataC  )
                (P.read $ ClassyPrelude.unpack newId)
                (P.read $ ClassyPrelude.unpack userId)
                )




instance FromJSON (PGArray Comment)
instance ToJSON (PGArray Comment)
deriving instance Generic (PGArray Comment) => Generic (PGArray Comment)


newtype TestArrayComment = TestArrayComment {
  array :: PGArray Comment
  } deriving (Show, Generic)

instance FromRow TestArrayComment 
instance  ToRow TestArrayComment 
  
