module Adapter.PostgreSQL.CommonService.CreateSpec where

import ClassyPrelude
import Test.Hspec
import Data.Time 
import qualified Prelude as Prelude

import Database.PostgreSQL.Simple
import Adapter.PostgreSQL.Common
import Domain.Service.CommonService
import Domain.Service.Auth 
import Domain.ImportEntity 
import Adapter.PostgreSQL.TestHelpPostgres

spec :: Spec
spec = beforeAll initDB $ do
  describe "create user" $ do
    it "should not create as session is fall "  $ do
            let s = SessionId ""
            user <- randomUser
            runTestApp (create s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
    it "should not create user as creator is not Admin"  $ do
        let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
        let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
        user <- randomUser
        runTestApp $ do
          s <- newSession userCreateNotAdmin
          val <-  create s (EntUser user)
          liftIO $ val `shouldBe` Left AccessErrorAdmin
    it "should create user "  $ do
            let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
            let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
            user <- randomUser
            runTestApp $ do
              s <- newSession userCreateAdmin
              val <-  create s (EntUser userCreateAdmin)
              liftIO $ val `shouldBe` Right ()

  -- describe "create author" $ do
  --   it "should not create as session is fall "  $ do
  --           let s = SessionId ""
  --           user <- randomUser
  --           runTestApp (create s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not create user as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       user <- randomUser
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  create s (EntUser user)
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should create user "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           user <- randomUser
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  create s (EntUser user)
  --             liftIO $ val `shouldBe` Right ()
  -- describe "create category1" $ do
  --   it "should not create as session is fall "  $ do
  --           let s = SessionId ""
  --           user <- randomUser
  --           runTestApp (create s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not create user as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       user <- randomUser
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  create s (EntUser user)
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should create user "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           user <- randomUser
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  create s (EntUser user)
  --             liftIO $ val `shouldBe` Right ()
  -- describe "create category2" $ do
  --   it "should not create as session is fall "  $ do
  --           let s = SessionId ""
  --           user <- randomUser
  --           runTestApp (create s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not create user as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       user <- randomUser
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  create s (EntUser user)
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should create user "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           user <- randomUser
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  create s (EntUser user)
  --             liftIO $ val `shouldBe` Right ()
  -- describe "create category3" $ do
  --   it "should not create as session is fall "  $ do
  --           let s = SessionId ""
  --           user <- randomUser
  --           runTestApp (create s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not create user as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       user <- randomUser
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  create s (EntUser user)
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should create user "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           user <- randomUser
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  create s (EntUser user)
  --             liftIO $ val `shouldBe` Right ()
  -- describe "create draft" $ do
  --   it "should not create as session is fall "  $ do
  --           let s = SessionId ""
  --           user <- randomUser
  --           runTestApp (create s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not create user as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       user <- randomUser
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  create s (EntUser user)
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should create user "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           user <- randomUser
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  create s (EntUser user)
  --             liftIO $ val `shouldBe` Right ()
  -- describe "create comment" $ do
  --   it "should not create as session is fall "  $ do
  --           let s = SessionId ""
  --           user <- randomUser
  --           runTestApp (create s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not create user as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       user <- randomUser
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  create s (EntUser user)
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should create user "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           user <- randomUser
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  create s (EntUser user)
  --             liftIO $ val `shouldBe` Right ()
  -- describe "create news" $ do
  --   it "should not create as session is fall "  $ do
  --           let s = SessionId ""
  --           user <- randomUser
  --           runTestApp (create s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not create user as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       user <- randomUser
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  create s (EntUser user)
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should create user "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           user <- randomUser
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  create s (EntUser user)
  --             liftIO $ val `shouldBe` Right ()
  -- describe "create teg" $ do
  --   it "should not create as session is fall "  $ do
  --           let s = SessionId ""
  --           user <- randomUser
  --           runTestApp (create s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not create user as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       user <- randomUser
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  create s (EntUser user)
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should create user "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           user <- randomUser
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  create s (EntUser user)
  --             liftIO $ val `shouldBe` Right ()