module Adapter.PostgreSQL.Auth.AuthSpec where

import ClassyPrelude
import Test.Hspec
import Data.Time 
import Domain.ImportEntity 

import Database.PostgreSQL.Simple
import Adapter.PostgreSQL.Common
import qualified Prelude as Prelude
import Domain.Service.Auth
import Adapter.PostgreSQL.TestHelpPostgres


spec :: Spec
spec = beforeAll initDB $ do
  describe "findUsers" $
    it "should return user  if the user already exists"  $ do
          user <- randomUser
          runTestApp (findUsers (authLogin user) (authPassword user) )  `shouldReturn` Left DataErrorPostgreSQL
          let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
          runTestApp (findUsers "3456ABCDefgh" "pasha@test.com"  )  `shouldReturn` Right (User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = True, authAuthor = True})
 


