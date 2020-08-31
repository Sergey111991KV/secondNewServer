module Config where

import ClassyPrelude
import System.Environment
import qualified Adapter.PostgreSQL.Common as PG
import Logging.Logging

data  Config  =  Config

  { configPort     ::  Int
  , configLog      ::  LogConfig
  , configPG       ::  PG.Config
  }


devConfig = Config
    { configPort = 3000
    , configLog = LogConfig { logFile = "log-journal"
                            , logLevelForFile = Debug
                            , logConsole = True }
    , configPG = PG.Config 
        { PG.configUrl = " host='localhost' port=5432 dbname='hblog'"
        , PG.configStripeCount = 2
        , PG.configMaxOpenConnPerStripe = 5
        , PG.configIdleConnTimeout = 10
        }
    }


