module Adapter.PostgreSQL.AuthSpec where

import ClassyPrelude
import Test.Hspec
-- import Domain.ImportService
import Domain.ImportEntity 

import Database.PostgreSQL.Simple
import Adapter.PostgreSQL.Common
import Adapter.PostgreSQL.Auth
import Text.StringRandom
import qualified Prelude as Prelude
-- import Adapter.Fixture
import Fixture
-- import Control.Monad.Catch (MonadThrow, MonadCatch)

-- import Data.Pool


-- type State = Pool Connection

-- -- findUsers                   :: Text -> Text -> m (Either Error User) -- password login
-- -- newSession                  :: User -> m SessionId
-- -- findUserBySession           :: SessionId -> m (Either Error User)
-- data Config = Config
--   { configUrl :: ByteString
--   , configStripeCount :: Int
--   , configMaxOpenConnPerStripe :: Int
--   , configIdleConnTimeout :: NominalDiffTime
--   }


-- instance Auth App where
--         findUsers = dispatch2 _findUsers
--         newSession = dispatch _newSession
--         findUserBySession = dispatch _findUserBySession



spec :: Spec
spec = beforeAll initDB $ do
  describe "findUsers" $
    it "should return user  if the user already exists"  pending 
        -- $ do
        -- user <- randomUser
    --   withState testConf (newSession user) `shouldReturn` (SessionId "sss")
        -- runTestApp  (findUsers (authLogin user) (authPassword user) >> findUsers (authLogin user) (authPassword user) ) `shouldReturn` Left LoginErrorInvalidAuth
    --   runTestApp (findUsers (authLogin user) (authPassword user)  >> findUsers (authLogin user) (authPassword user)) `shouldReturn` Left LoginErrorInvalidAuth




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
   