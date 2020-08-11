module Domain.Parse.ParsePostgresTypes where

import Domain.Types.Imports
import Database.PostgreSQL.Simple.FromField 
import ClassyPrelude
import qualified Data.Attoparsec.ByteString.Char8 as A
import qualified Data.ByteString.Char8                as B
import qualified Prelude as P
import Database.PostgreSQL.Simple.Types 
import qualified Text.Parsec as Parsec
import Control.Applicative




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




splitBy :: (a -> Bool) -> [a] -> [[a]]
splitBy _ [] = []
splitBy f list = first : splitBy f (P.dropWhile f rest) where
  (first, rest) = P.break f list


getCurrentArray ::  [String] -> [String]
getCurrentArray [] = []
getCurrentArray (x:xs) 
                        | x == [','] =  getCurrentArray xs
                        | x == "}" =  getCurrentArray xs
                        | x == "{" =  getCurrentArray xs
                        | x == ['"'] =  getCurrentArray xs
                        | x == "" =  getCurrentArray xs
                        | otherwise = x : getCurrentArray xs

textContentArray :: A.Parser [Text]
-- textContentArray = undefined
textContentArray = do
      t <- scobe
      let a = getCurrentArray $ splitBy (== '"') $ ClassyPrelude.unpack t
      return (fmap ClassyPrelude.pack a)




scobe :: A.Parser Text
scobe = decodeUtf8 <$> (A.char '{' *> A.option "" contents <* A.char '}')
  where
    esc = A.char '{' *> (A.char '{' <|> A.char '}')
    unQ = A.takeWhile1 (A.notInClass "}")
    contents = mconcat <$> many (unQ <|> B.singleton <$> esc)


-- parseMy :: A.Parser String
-- parseMy = pure (:) <*> .... <*> parseMy <|> pure ""


-- mySeparator ::  A.Parser ()
-- mySeparator = do
--     A.space
--     A.char '"'
--     A.space





fromPGRow :: Typeable a => String -> A.Parser a -> Field -> Maybe ByteString -> Conversion a
fromPGRow _ _ f Nothing = returnError UnexpectedNull f ""
fromPGRow fname parser f (Just bs) = do
  typename' <- typename f
  if typename' /= B.pack fname
    then returnError Incompatible f ("Wanted " <> fname <> ", got " <> show typename')
    else case A.parseOnly parser bs of
           Left err -> returnError ConversionFailed f err
           Right a  -> pure a


timeToByteStr :: UTCTime -> ByteString
timeToByteStr = B.pack . formatTime defaultTimeLocale "%Y-%m-%dT%H:%M:%S"

time = ( P.read "1970-01-01 00:00:00.000000 UTC" )::UTCTime

timeFromByteString :: Text -> UTCTime
timeFromByteString  s = case  (timeFromByteString' s) of
          Nothing -> time
          Just t  -> zonedTimeToUTC t

timeFromByteString' :: Text -> Maybe ZonedTime
timeFromByteString' s =  parseTimeM True defaultTimeLocale  "%Y" (ClassyPrelude.unpack  s) :: Maybe ZonedTime


parseTextToPGArrayText :: [Text] -> PGArray Text
parseTextToPGArrayText text =  PGArray text