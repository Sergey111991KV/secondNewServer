module Logging.LogEntity where

import ClassyPrelude
import Data.Aeson
import GHC.Generics
import Data.Text.Time
import System.IO.Unsafe
import System.IO
import Domain.Types.Error
import Domain.ImportEntity 


type LoggingInConfig = Logging

data LogConfig = LogConfig
  { logFile :: FilePath
  , logLevelForFile :: LoggingInConfig
  , logConsole :: Bool
  } deriving (Show, Generic)

type LogForFile =  Logging 

data Logging
  = Debug
  | Warning
  | Error
  deriving (Eq, Ord, Read, Show, Generic)

takeValueLogging :: Logging -> Integer
takeValueLogging log
                | log == Debug     = 1
                | log == Warning   = 2
                | log == Logging.LogEntity.Error     = 3

caseOfWriteLogging :: Logging -> LogForFile -> Bool
caseOfWriteLogging log logConf =  (takeValueLogging log) >= (takeValueLogging logConf)

instance ToJSON Logging

instance FromJSON Logging


instance ToJSON LogConfig

instance FromJSON LogConfig
