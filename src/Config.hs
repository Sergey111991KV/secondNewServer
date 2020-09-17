module Config where

import qualified Adapter.PostgreSQL.Common as PG
import ClassyPrelude
import qualified Logging.ImportLogging as Log
import System.Environment

data Config =
  Config
    { configPort :: Int
    , configLog :: Log.State
    , configPG :: PG.Config
    }

devConfig =
  Config
    { configPort = 3000
    , configLog =
        Log.State
          { logStCong =
              Log.LogConfig
                { logFile = "log-journal"
                , logLevelForFile = Log.Debug
                , logConsole = True
                }
          }
    , configPG =
        PG.Config
          { PG.configUrl = " host='localhost' port=5432 dbname='postgres'"
          , PG.configStripeCount = 2
          , PG.configMaxOpenConnPerStripe = 5
          , PG.configIdleConnTimeout = 10
          }
    }
