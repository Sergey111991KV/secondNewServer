module Logging.Logging where

import ClassyPrelude
import Control.Monad
import Data.Aeson
import qualified Data.ByteString as B
import qualified Data.Text.Encoding as T
import Data.Text.Time
import Domain.ImportEntity
import Domain.Types.Error
import GHC.Generics
import Logging.LogEntity
import System.IO
import System.IO.Unsafe

import qualified Data.ByteString.Lazy as BL

toStrict1 :: BL.ByteString -> B.ByteString
toStrict1 = B.concat . BL.toChunks

writeInLogFile :: FilePath -> Bool -> Text -> IO ()
writeInLogFile lF bl txt = do
  when bl $ appendFile lF (ClassyPrelude.unpack txt)

writeInTerminal :: Bool -> Text -> IO ()
writeInTerminal bl txt = do
  when bl $ ClassyPrelude.putStrLn txt

writFileHandler ::
     FilePath -> LoggingInConfig -> Logging -> Bool -> Text -> IO ()
writFileHandler lF logCong log bl txt = do
  let ifWrite = caseOfWriteLogging logCong log
  writeInLogFile lF ifWrite txt
  writeInTerminal bl txt

writeTextError :: Error -> String -> String
writeTextError err txt = date ++ errText ++ txt
  where
    date = takeCurrentDate
    errText = errorString err

writeText :: String -> String
writeText txt = date ++ txt
  where
    date = takeCurrentDate

takeCurrentDate :: String
takeCurrentDate =
  ClassyPrelude.unpack $ formatISODateTime $ unsafePerformIO time
  where
    time = getCurrentTime

writeLogginHandler :: LogConfig -> Logging -> Text -> IO ()
writeLogginHandler (LogConfig lf logLev logBool) loging =
  writFileHandler lf logLev loging logBool
