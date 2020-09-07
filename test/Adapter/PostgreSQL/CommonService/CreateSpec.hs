module Adapter.PostgreSQL.CommonService.CreateSpec where

import ClassyPrelude
import Test.Hspec
import Data.Time 
import Domain.ImportEntity 

import Database.PostgreSQL.Simple
import Adapter.PostgreSQL.Common
import Domain.Service.CommonService
-- import qualified Adapter.PostgreSQL.CommonService.Сreate as Cr

import Adapter.PostgreSQL.TestHelpPostgres

spec :: Spec
spec = beforeAll initDB $ do
  describe "create" $
    it "should create user  if the user already right"  $ do
            let s = SessionId "nonSession"
            user <- randomUser
            runTestApp (create s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
