module Domain.Types.Teg where

import ClassyPrelude
import qualified Data.Attoparsec.ByteString.Char8 as A
import qualified Data.ByteString.Char8 as B
import Database.PostgreSQL.Simple.FromField
import Database.PostgreSQL.Simple.Types
import Domain.Parse.ParsePostgresTypes
import Domain.Types.Imports
import qualified Prelude as P

data Teg =
  Teg
    { id_teg :: Int
    , name_teg :: String
    }
  deriving (Show, Generic)

instance FromRow Teg

instance ToRow Teg

instance FromJSON Teg

instance ToJSON Teg

instance FromField Teg where
  fromField = fromPGRow "teg_type" parseTeg

parseTeg :: A.Parser Teg
parseTeg = do
  _ <- A.char '('
  id_teg <- textContent
  _ <- A.char ','
  name_teg <- textContent
  _ <- A.char ')'
  pure
    (Teg (P.read $ ClassyPrelude.unpack id_teg) (ClassyPrelude.unpack name_teg))

instance ToField Teg where
  toField (Teg idT text) =
    Many
      [ Plain "row("
      , Plain (intDec idT)
      , Plain ","
      , Escape (fromString text)
      , Plain ")"
      ]

instance FromJSON (PGArray Teg)

instance ToJSON (PGArray Teg)

deriving instance Generic (PGArray Teg) => Generic (PGArray Teg)

newtype TestArrayTeg =
  TestArrayTeg
    { arrays :: PGArray Teg
    }
  deriving (Show, Generic)

instance FromRow TestArrayTeg

instance ToRow TestArrayTeg
