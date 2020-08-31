module Logging.LogMonad where

import ClassyPrelude
import Data.Aeson
import GHC.Generics
import Data.Text.Time
import System.IO.Unsafe
import System.IO
import Domain.Types.Error
import Logging.Logging 


class (Monad m) =>  Log m  where
    logIn :: Logging -> Text ->  m ()