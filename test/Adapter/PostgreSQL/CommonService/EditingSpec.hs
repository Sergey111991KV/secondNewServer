module Adapter.PostgreSQL.CommonService.EditingSpec where

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
import Database.PostgreSQL.Simple.Types 

-- pending

-- spec :: Spec
-- spec = beforeAll initDB $ do
--   describe "create user" $ do 
--         it "should not create as session is fall " pending
time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
--           

spec :: Spec
spec = beforeAll initDB $ do
   
  -- describe "editing user" $ do
  --   it "should not editing as session is fall "  $ do
  --           let s = SessionId ""
  --           user <- randomUser
  --           runTestApp (editing s (EntUser user))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not editing user as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@tessfsdt.com", authPassword = "3456ABsfsdCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       user <- randomUser
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  editing s (EntUser user)
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should create user "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "test", lastName = "test", authLogin = "pasha@test.comsdfs", authPassword = "3456ABCDefghdsfsd", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  editing s (EntUser userCreateAdmin)
  --             liftIO $ val `shouldBe` Right ()

  -- describe "editing author" $ do
  --   it "should not editing author as session is fall "  $ do
  --           let s = SessionId ""
  --           auth <- randomAuthor
  --           runTestApp (editing s (EntAuthor auth))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not editing author as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       let auth = Author 2 "test" userCreateNotAdmin
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  editing s (EntAuthor auth)
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should editing author "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           let auth = Author 2 "test" userCreateAdmin
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  editing s (EntAuthor auth)
  --             liftIO $ val `shouldBe` Right ()


  
  -- describe "editing category1" $ do
  --   it "should not editing category1 as session is fall "  $ do
  --           let s = SessionId ""
  --           cat <- randomCategory1
  --           runTestApp (create s (EntCategory (CatCategory1 cat)))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not editing category1 as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       cat <- randomCategory1
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  editing s (EntCategory (CatCategory1 cat))
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should editing category1 "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           let cat = Category1 4 "Health"
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  editing s (EntCategory (CatCategory1 cat))
  --             liftIO $ val `shouldBe` Right ()
  -- describe "editing category2" $ do
  --   it "should not editing as session is fall "  $ do
  --           let s = SessionId ""
  --           cat <- randomCategory2
  --           runTestApp (editing s (EntCategory (CatCategory2 cat)))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not editing category2 as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       cat <- randomCategory2
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  editing s (EntCategory (CatCategory2 cat))
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should editing category2 "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           let cat = Category2 7 "Meditation" (Category1 4 "Health")
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  editing s (EntCategory (CatCategory2 cat))
  --             liftIO $ val `shouldBe` Right ()
  -- describe "editing category3" $ do
  --   it "should not editing category3 as session is fall "  $ do
  --           let s = SessionId ""
  --           cat <- randomCategory3
  --           runTestApp (editing s (EntCategory (CatCategory3 cat)))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not editing category3 as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       cat <- randomCategory3
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  editing s (EntCategory (CatCategory3 cat))
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should editing category3 "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           let cat = Category3 14 "Meditation in India" (Category2 7 "Meditation" (Category1 4 "Health"))
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  editing s (EntCategory (CatCategory3 cat))
  --             liftIO $ val `shouldBe` Right ()
  -- describe "editing draft" $ do
  --   it "should not editing draft as session is fall "  $ do
  --           let s = SessionId ""
  --           draft <- randomDraft
  --           runTestApp (editing s (EntDraft draft))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not editing draft as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAuthor = User {id_user = 3, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = False}
  --       draft <- randomDraft
  --       runTestApp $ do
  --         s <- newSession userCreateNotAuthor
  --         val <-  editing s (EntDraft draft)
  --         liftIO $ val `shouldBe` Left AccessErrorAuthor
  --   it "should editing draft "  $ do
  --           let pgArrayText = PGArray ["test 1 other photo", "test 1 other photo2"]
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           let draft  = Draft 3 "test 3 draft" time 1 "test 2 main photo url" pgArrayText "TestDragtForFirstNews"
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  editing s (EntDraft draft)
  --             liftIO $ val `shouldBe` Right ()
  describe "editing comment" $ do
    it "should create comment everybody - also not authorithation"  $ do
            -- let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
        --          
            let comment = Comment 5 "test comment4" time 1 1
            runTestApp $ do
              s <- newSession userCreateAdmin
              val <-  editing s (EntComment comment)
              liftIO $ val `shouldBe` Right ()
  -- describe "editing news" $ do
  --   it "should not editing news as session is fall "  $ do
  --           let s = SessionId ""
  --           news <- randomNews
  --           runTestApp (editing s (EntNews news))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not editing news as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAuthor = User {id_user = 3, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = False}
  --       news <- randomNews
  --       runTestApp $ do
  --         s <- newSession userCreateNotAuthor
  --         val <-  editing s (EntNews news)
  --         liftIO $ val `shouldBe` Left AccessErrorAuthor
  --   it "should editing news "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAuthor = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           news <- randomNews
  --           runTestApp $ do
  --             s <- newSession userCreateAuthor
  --             val <-  editing s (EntNews news)
  --             liftIO $ val `shouldBe` Right ()
  -- describe "editing teg" $ do
  --   it "should not editing teg as session is fall "  $ do
  --           let s = SessionId ""
  --           teg <- randomTeg
  --           runTestApp (editing s (EntTeg teg))  `shouldReturn` Left UserErrorFindBySession
  --   it "should not editing teg as creator is not Admin"  $ do
  --       let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --       let userCreateNotAdmin = User {id_user = 2, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --       teg <- randomTeg
  --       runTestApp $ do
  --         s <- newSession userCreateNotAdmin
  --         val <-  editing s (EntTeg teg)
  --         liftIO $ val `shouldBe` Left AccessErrorAdmin
  --   it "should editing teg "  $ do
  --           let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
  --           let userCreateAdmin = User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = False, authAuthor = True}
  --           teg <- randomTeg
  --           runTestApp $ do
  --             s <- newSession userCreateAdmin
  --             val <-  editing s (EntTeg teg)
  --             liftIO $ val `shouldBe` Right ()