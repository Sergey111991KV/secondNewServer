module Adapter.PostgreSQL.Auth.AuthSpec where

import ClassyPrelude
import Test.Hspec
import Data.Time 
import Domain.ImportEntity 

import Database.PostgreSQL.Simple
import Adapter.PostgreSQL.Common
import qualified Adapter.PostgreSQL.Auth.Auth as Auth
import Text.StringRandom
import qualified Prelude as Prelude
import Domain.Service.Auth
import Logging.LogMonad
import Logging.Logging
import qualified Config as Config

instance Auth (ReaderT State IO ) where
        findUsers = Auth.findUsers
        newSession = Auth.newSession
        findUserBySession = Auth.findUserBySession
      
instance Log (ReaderT State IO ) where
  logIn log txt = do
    let confLog = Config.configLog Config.devConfig 
    liftIO $ writeLogginHandler confLog log txt
      


spec :: Spec
spec = beforeAll initDB $ do
  describe "findUsers" $
    it "should return user  if the user already exists"  $ do
          user <- randomUser
          runTestApp (findUsers (authLogin user) (authPassword user) )  `shouldReturn` Left DataErrorPostgreSQL
          
          let time = ( Prelude.read "2015-09-01 13:34:02 UTC" )::UTCTime
          runTestApp (findUsers "3456ABCDefgh" "pasha@test.com"  )  `shouldReturn` Right (User {id_user = 1, nameU = "Pasha", lastName = "Dragon", authLogin = "pasha@test.com", authPassword = "3456ABCDefgh", avatar = "https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory", dataCreate = time, authAdmin = True, authAuthor = True})




initDB :: IO ()
initDB = do
  conn <- connectPostgreSQL "postgresql://localhost"
  close conn
  withState testConf (const $ return ())

testConf :: Config
testConf =
  Config  { configUrl = " host='localhost' port=5432 dbname='hblog'"
          , configStripeCount = 2
          , configMaxOpenConnPerStripe = 5
          , configIdleConnTimeout = 10
          } 

runTestApp :: ReaderT State IO a -> IO a
runTestApp action = withPool testConf $ runReaderT action


-- newtype App a = App
--     { unApp :: ReaderT State IO a
--     } deriving (Applicative, Functor, Monad, MonadReader State, MonadIO, MonadThrow)
  
-- run :: State -> App a -> IO a
-- run  state =  flip runReaderT state . unApp

-- withPool :: Config -> (State -> IO a) -> IO a
-- withPool cfg action =
--     bracket initPool cleanPool action
--         where
--           initPool = createPool openConn closeConn
--                       (configStripeCount cfg)
--                       (configIdleConnTimeout cfg)
--                       (configMaxOpenConnPerStripe cfg)
--           cleanPool = destroyAllResources
--           openConn = connectPostgreSQL (configUrl cfg)
--           closeConn = close

-- withState  ::  Config  -> ( State  ->  IO  a ) ->  IO  a
-- withState cfg action =
--     withPool cfg $ \state -> do
--         action state



randomUser :: IO User
randomUser = do
  let time = ( Prelude.read "2011-11-19 18:28:52.607875 UTC" ) :: UTCTime
  name <- stringRandomIO "[A-Za-z0]{16}"
  lastName <- stringRandomIO "[A-Za-z0]{16}"
  login <- stringRandomIO "[A-Za-z0]{16}"
  password <- stringRandomIO "[A-Za-z0]{16}"
  return $ User 26 name lastName login password "avatar" time True True  
   