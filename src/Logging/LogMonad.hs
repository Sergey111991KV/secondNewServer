module Logging.LogMonad where

import ClassyPrelude
import Data.Aeson
import Data.Text.Time
import Domain.Types.Error
import GHC.Generics
import Logging.LogEntity
import Logging.Logging
import System.IO
import System.IO.Unsafe

newtype State =
  State
    { logStCong :: LogConfig
    }

class (Monad m) =>
      Log m
  where
  logIn :: Logging -> Text -> m ()
