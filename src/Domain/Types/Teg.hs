module Domain.Types.Teg where

import Domain.Types.Imports
import Database.PostgreSQL.Simple.FromField 
import ClassyPrelude
import qualified Data.Attoparsec.ByteString.Char8 as A
import qualified Data.ByteString.Char8                as B
import qualified Prelude as P
import Domain.Parse.ParsePostgresTypes


data Teg = Teg {
    id_teg   :: Int,
    name_teg :: String
    } deriving (Show, Generic)

instance FromRow Teg where
 fromRow  = Teg <$> field <*> field
instance  ToRow Teg where
    toRow t = [toField t]
  
instance FromJSON Teg
instance ToJSON Teg

instance FromField Teg where
  fromField = fromPGRow "teg_type" parseTeg 

parseTeg :: A.Parser Teg
parseTeg = do
  _ <- A.char '('
  id_teg <- textContent 
  _ <- A.char ','
  name_teg <-  textContent
  _ <- A.char ')'
  pure (Teg (P.read $ ClassyPrelude.unpack $ id_teg) ( ClassyPrelude.unpack name_teg))


instance ToField Teg where
  toField (Teg idT text) = 
        Many [
            Plain "row("
          , Plain (intDec idT)
          , Plain ","
          , Escape (fromString text)
          , Plain ")"
        ]



instance FromField [Teg] where
  fromField = fromJSONField 
instance ToField [Teg] where
  toField = toJSONField 
