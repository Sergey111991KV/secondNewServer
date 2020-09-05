module Config where

import ClassyPrelude
import System.Environment
import qualified Adapter.PostgreSQL.Common as PG
import qualified Logging.ImportLogging as Log


data  Config  =  Config

  { configPort     ::  Int
  , configLog      ::  Log.State
  , configPG       ::  PG.Config
  }


devConfig = Config
    { configPort = 3000
    , configLog = Log.State { logStCong = Log.LogConfig { logFile = "log-journal"
                                                        , logLevelForFile = Log.Debug
                                                        , logConsole = True } }
    , configPG = PG.Config 
        { PG.configUrl = " host='localhost' port=5432 dbname='hblog'"
        , PG.configStripeCount = 2
        , PG.configMaxOpenConnPerStripe = 5
        , PG.configIdleConnTimeout = 10
        }
    }


