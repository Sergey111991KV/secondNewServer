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


-- pending

spec :: Spec
spec = beforeAll initDB $ do
  describe "create user" $ do 
        it "should not create as session is fall " pending
time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--           

-- spec :: Spec
-- spec = beforeAll initDB $ do
--   describe "create user" $ do
--     it "should not create as session is fall "  $ do
--             let s = SessionId ""
--             user <- randomUser
--             runTestApp (create s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
--     it "should not create user as creator is not Admin"  $ do
--         let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--         let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@tessfsdt.com", authPassword = "3456ABsfsdCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--         user <- randomUser
--         runTestApp $ do
--           s <- newSession userCreateNotAdmin
--           val <-  create s (EntUser user)
--           liftIO $ val `shouldBe` Left AccessErrorAdmin
--     it "should create user "  $ do
--             let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--             let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.comsdfs", authPassword = "3456ABCDefghdsfsd", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--             user <- randomUser
--             runTestApp $ do
--               s <- newSession userCreateAdmin
--               val <-  create s (EntUser userCreateAdmin)
--               liftIO $ val `shouldBe` Right ()

--   describe "create author" $ do
--     it "should not create author as session is fall "  $ do
--             let s = SessionId ""
--             auth <- randomAuthor
--             runTestApp (create s (EntAuthor auth))  `shouldReturn` Left UserErrorFindBySession
--     it "should not create author as creator is not Admin"  $ do
--         let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--         let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--         auth <- randomAuthor
--         runTestApp $ do
--           s <- newSession userCreateNotAdmin
--           val <-  create s (EntAuthor auth)
--           liftIO $ val `shouldBe` Left AccessErrorAdmin
--     it "should create author "  $ do
--             let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--             let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--             auth <- randomAuthor
--             runTestApp $ do
--               s <- newSession userCreateAdmin
--               val <-  create s (EntAuthor auth)
--               liftIO $ val `shouldBe` Right ()
--   describe "create category1" $ do
--     it "should not create category1 as session is fall "  $ do
--             let s = SessionId ""
--             cat <- randomCategory1
--             runTestApp (create s (EntCategory (CatCategory1 cat)))  `shouldReturn` Left UserErrorFindBySession
--     it "should not create category1 as creator is not Admin"  $ do
--         let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--         let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--         cat <- randomCategory1
--         runTestApp $ do
--           s <- newSession userCreateNotAdmin
--           val <-  create s (EntCategory (CatCategory1 cat))
--           liftIO $ val `shouldBe` Left AccessErrorAdmin
--     it "should create category1 "  $ do
--             let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--             let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--             cat <- randomCategory1
--             runTestApp $ do
--               s <- newSession userCreateAdmin
--               val <-  create s (EntCategory (CatCategory1 cat))
--               liftIO $ val `shouldBe` Right ()
--   describe "create category2" $ do
--     it "should not create as session is fall "  $ do
--             let s = SessionId ""
--             cat <- randomCategory2
--             runTestApp (create s (EntCategory (CatCategory2 cat)))  `shouldReturn` Left UserErrorFindBySession
--     it "should not create category2 as creator is not Admin"  $ do
--         let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--         let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--         cat <- randomCategory2
--         runTestApp $ do
--           s <- newSession userCreateNotAdmin
--           val <-  create s (EntCategory (CatCategory2 cat))
--           liftIO $ val `shouldBe` Left AccessErrorAdmin
--     it "should create category2 "  $ do
--             let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--             let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--             cat <- randomCategory2
--             runTestApp $ do
--               s <- newSession userCreateAdmin
--               val <-  create s (EntCategory (CatCategory2 cat))
--               liftIO $ val `shouldBe` Right ()
--   describe "create category3" $ do
--     it "should not create category3 as session is fall "  $ do
--             let s = SessionId ""
--             cat <- randomCategory3
--             runTestApp (create s (EntCategory (CatCategory3 cat)))  `shouldReturn` Left UserErrorFindBySession
--     it "should not create category3 as creator is not Admin"  $ do
--         let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--         let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--         cat <- randomCategory3
--         runTestApp $ do
--           s <- newSession userCreateNotAdmin
--           val <-  create s (EntCategory (CatCategory3 cat))
--           liftIO $ val `shouldBe` Left AccessErrorAdmin
--     it "should create category3 "  $ do
--             let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--             let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--             cat <- randomCategory3
--             runTestApp $ do
--               s <- newSession userCreateAdmin
--               val <-  create s (EntCategory (CatCategory3 cat))
--               liftIO $ val `shouldBe` Right ()
--   describe "create draft" $ do
--     it "should not create draft as session is fall "  $ do
--             let s = SessionId ""
--             draft <- randomDraft
--             runTestApp (create s (EntDraft draft))  `shouldReturn` Left UserErrorFindBySession
--     it "should not create draft as creator is not Admin"  $ do
--         let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--         let userCreateNotAuthor = User {id_user = 3, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = False}
--         draft <- randomDraft
--         runTestApp $ do
--           s <- newSession userCreateNotAuthor
--           val <-  create s (EntDraft draft)
--           liftIO $ val `shouldBe` Left AccessErrorAuthor
--     it "should create draft "  $ do
--             let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--             let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--             draft <- randomDraft
--             runTestApp $ do
--               s <- newSession userCreateAdmin
--               val <-  create s (EntDraft draft)
--               liftIO $ val `shouldBe` Right ()
--   describe "create comment" $ do
--     it "should not create comment as session is fall "  $ do
--             let s = SessionId ""
--             com <- randomComment
--             runTestApp (create s (EntComment com))  `shouldReturn` Left UserErrorFindBySession
--     it "should create comment everybody - also not authorithation"  $ do
--             let userCreateNotAuthor = User {id_user = 3, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = False}     
--             com <- randomComment
--             runTestApp $ do
--               s <- newSession userCreateAdmin
--               val <-  create s (EntComment com)
--               liftIO $ val `shouldBe` Right ()
--   describe "create news" $ do
--     it "should not create news as session is fall "  $ do
--             let s = SessionId ""
--             news <- randomNews
--             runTestApp (create s (EntNews news))  `shouldReturn` Left UserErrorFindBySession
--     it "should not create news as creator is not Admin"  $ do
--         let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--         let userCreateNotAuthor = User {id_user = 3, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = False}
--         news <- randomNews
--         runTestApp $ do
--           s <- newSession userCreateNotAuthor
--           val <-  create s (EntNews news)
--           liftIO $ val `shouldBe` Left AccessErrorAuthor
--     it "should create news "  $ do
--             let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--             let userCreateAuthor = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--             news <- randomNews
--             runTestApp $ do
--               s <- newSession userCreateAuthor
--               val <-  create s (EntNews news)
--               liftIO $ val `shouldBe` Right ()
--   describe "create teg" $ do
--     it "should not create teg as session is fall "  $ do
--             let s = SessionId ""
--             teg <- randomTeg
--             runTestApp (create s (EntTeg teg))  `shouldReturn` Left UserErrorFindBySession
--     it "should not create teg as creator is not Admin"  $ do
--         let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--         let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--         teg <- randomTeg
--         runTestApp $ do
--           s <- newSession userCreateNotAdmin
--           val <-  create s (EntTeg teg)
--           liftIO $ val `shouldBe` Left AccessErrorAdmin
--     it "should create teg "  $ do
--             let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
--             let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--             teg <- randomTeg
--             runTestApp $ do
--               s <- newSession userCreateAdmin
--               val <-  create s (EntTeg teg)
--               liftIO $ val `shouldBe` Right ()