module Logging.Logging where

import ClassyPrelude
import Data.Aeson
import GHC.Generics
import Data.Text.Time
import System.IO.Unsafe
import System.IO
import Domain.Types.Error
import Domain.ImportEntity 
import Logging.LogEntity
import qualified Data.Text.Encoding as T
import qualified Data.ByteString               as B

import qualified Data.ByteString.Lazy          as BL

toStrict1 :: BL.ByteString -> B.ByteString
toStrict1 = B.concat . BL.toChunks

-- entityToText :: Entity -> Text
-- EntAuthor   Author   | 
-- entityToText   EntCategory Category   | 
-- entityToText  EntComment  Comment  | 
-- entityToText (EntDraft    Draft    |
-- entityToText (EntNews     News)     | 
-- entityToText  (EntUser    User)    | 
-- entityToText  (EntTeg      Teg)
-- entityToText ent = T.decodeUtf8 $ toStrict1 $ encode $ convertFromEntity ent



writeInLogFile :: FilePath -> Bool -> Text -> IO ()
writeInLogFile lF bl txt = do
        case bl of
            True -> appendFile lF ( ClassyPrelude.unpack txt)
            False -> return ()

writeInTerminal :: Bool -> Text -> IO ()
writeInTerminal bl txt = do
        case bl of
                True -> do
                        ClassyPrelude.putStrLn txt
                False -> return ()

 
writFileHandler ::  FilePath -> LoggingInConfig -> Logging -> Bool -> Text -> IO ()
writFileHandler lF logCong log bl txt = do
        let ifWrite =  caseOfWriteLogging logCong log
        writeInLogFile lF ifWrite txt
        writeInTerminal bl txt  

writeTextError      :: Error -> String -> String
writeTextError  err txt    =  date ++  errText ++  txt
                where
                        date    = takeCurrentDate
                        errText = errorString err
      

writeText :: String ->  String
writeText txt = date ++  txt
        where
                date    = takeCurrentDate

        
takeCurrentDate ::  String
takeCurrentDate = ClassyPrelude.unpack  $ formatISODateTime $ unsafePerformIO time
        where 
                time = getCurrentTime
     
writeLogginHandler :: LogConfig -> Logging -> Text -> IO ()
writeLogginHandler  (LogConfig lf logLev logBool) loging txt =  writFileHandler lf logLev loging logBool txt


