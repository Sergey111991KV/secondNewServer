module Adapter.PostgreSQL.SearchIn where

import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common
import  Data.Either
import  Control.Monad.Trans
import GHC.Exception.Type
import ClassyPrelude
import Data.Text
import qualified Data.ByteString.Lazy as B


searchInContent :: PG r m => Text -> m (Either Error [News] )
searchInContent = undefined

-- API новостей должно поддерживать поиск по строке, которая может быть найдена либо в текстовом контенте,
searchInEntyty  :: PG r m =>Text -> m (Either Error [News] )    --  либо в имени автора, либо в названии категории/тега
searchInEntyty = undefined