module Domain.Types.Draft where

import Domain.Types.Imports
import Database.PostgreSQL.Simple.FromField 
import ClassyPrelude
import Database.PostgreSQL.Simple.Types 
-- import Database.PostgreSQL.Simple.Arrays
import qualified Data.Attoparsec.ByteString.Char8 as A
import           Data.ByteString.Builder
import           Data.ByteString
import Data.ByteString.Internal
import qualified Prelude as P
import Domain.Parse.ParsePostgresTypes


data Draft = Draft 
    { id_draft          :: Int
    , text_draft        :: String
    , data_create_draft  :: UTCTime
    , news_id_draft      :: Int
    , main_photo_url    :: String
    , other_photo_url   :: PGArray Text
    , short_name        :: String
    } deriving (Show, Generic)

instance FromRow Draft 
instance  ToRow Draft

instance FromJSON Draft
instance ToJSON Draft


instance FromField Draft where
    fromField = fromPGRow "drafts_type" parseDraft 


parseDraft :: A.Parser Draft
parseDraft = do
  _ <- A.char '('
  idD <- textContent 
  _ <- A.char ','
  text <-  textContent
  _ <- A.char ','
  dataTime <- textContent 
  _ <- A.char ','
  newId <-  textContent
  _ <- A.char ','
  mainP <- textContent 
  _ <- A.char ','
  _ <- A.char '"'
  othrP <- textContentArray 
  _ <- A.char '"'
  _ <- A.char ','
  sname <- textContent 
  _ <- A.char ')'
  pure (Draft (P.read $ ClassyPrelude.unpack idD) 
                (ClassyPrelude.unpack text)  
                (timeFromByteString dataTime  )
                (P.read $ ClassyPrelude.unpack newId)
                (ClassyPrelude.unpack mainP) 
                (parseTextToPGArrayText othrP) 
                (ClassyPrelude.unpack sname)
                )

instance ToField Draft where
    toField (Draft idD text dataTime newid mainP othrP sname) = 
        Many [
            Plain "row("
          , Plain (intDec idD)
          , Plain ","
          , Escape (fromString text)
          , Plain ","
          , Escape (timeToByteStr dataTime)
          , Plain ")"
          , Plain (intDec newid)
          , Plain ","
          , Escape (fromString mainP)
          , Plain ","

          -- , Escape (fromString othrP)
          , Plain ","

          , Escape (fromString sname)
        ]



instance FromJSON (PGArray Text)
instance ToJSON (PGArray Text)
deriving instance Generic (PGArray Text) => Generic (PGArray Text)

instance FromJSON (PGArray Draft)
instance ToJSON (PGArray Draft)

deriving instance Generic (PGArray Draft) => Generic (PGArray Draft)

newtype TestArrayDraft = TestArrayDraft {
  arrayd :: PGArray Draft
  } deriving (Show, Generic)

instance FromRow TestArrayDraft 
instance  ToRow TestArrayDraft 
  