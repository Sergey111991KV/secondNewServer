module Domain.Parse.ParsePostgresTypes where

import Domain.Types.Imports
import Database.PostgreSQL.Simple.FromField 
import ClassyPrelude
import qualified Data.Attoparsec.ByteString.Char8 as A
import qualified Data.ByteString.Char8                as B
import qualified Prelude as P



textContent :: A.Parser Text
textContent = decodeUtf8 <$> (quoted <|> plain)


quoted :: A.Parser ByteString
quoted = A.char '"' *> A.option "" contents <* A.char '"'
  where
    esc = A.char '\\' *> (A.char '\\' <|> A.char '"')
    unQ = A.takeWhile1 (A.notInClass "\"\\")
    contents = mconcat <$> many (unQ <|> B.singleton <$> esc)

-- | Recognizes a plain string literal, not containing comma, quotes, or parens.
plain :: A.Parser ByteString
plain = A.takeWhile1 (A.notInClass ",\"()")



fromPGRow :: Typeable a => String -> A.Parser a -> Field -> Maybe ByteString -> Conversion a
fromPGRow _ _ f Nothing = returnError UnexpectedNull f ""
fromPGRow fname parser f (Just bs) = do
  typename' <- typename f
  if typename' /= B.pack fname
    then returnError Incompatible f ("Wanted " <> fname <> ", got " <> show typename')
    else case A.parseOnly parser bs of
           Left err -> returnError ConversionFailed f err
           Right a  -> pure a


