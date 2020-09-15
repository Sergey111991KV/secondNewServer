module Logging.LogMonad where

import ClassyPrelude
import Data.Aeson
import GHC.Generics
import Data.Text.Time
import System.IO.Unsafe
import System.IO
import Domain.Types.Error
import Logging.Logging 
import Logging.LogEntity


newtype State = State {
    logStCong :: LogConfig
    }

class (Monad m) =>  Log m  where
    logIn :: Logging -> Text ->  m ()