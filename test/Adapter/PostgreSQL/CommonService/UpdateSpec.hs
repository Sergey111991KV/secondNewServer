module Adapter.PostgreSQL.CommonService.UpdateSpec where

import ClassyPrelude
import Test.Hspec
import Data.Time 
import Domain.ImportEntity 

import Database.PostgreSQL.Simple
import Adapter.PostgreSQL.Common
import Domain.Service.CommonService
import Domain.Service.Auth 
import qualified Prelude as Prelude
import Adapter.PostgreSQL.TestHelpPostgres


spec :: Spec
spec = beforeAll initDB $ do
  describe "create user" $ do 
        it "should not create as session is fall " pending