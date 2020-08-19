module Domain.Service.AuthSpec where

import ClassyPrelude
import Domain.ImportService
import Domain.ImportEntity 
import Test.Hspec
import Fixture
import Data.Time.LocalTime
import qualified Prelude as Prelude
import System.IO.Unsafe

-- findUsers                   :: Text -> Text -> m (Either Error User) -- password login
-- newSession                  :: User -> m SessionId
-- findUserBySession           :: SessionId -> m (Either Error User)

instance Auth App where
        findUsers = dispatch2 _findUsers
        newSession = dispatch _newSession
        findUserBySession = dispatch _findUserBySession

data Fixture m = Fixture
  { _findUsers                   :: Text -> Text -> m (Either Error User)
  ,  _newSession                 :: User -> m SessionId
  , _findUserBySession           :: SessionId -> m (Either Error User)
  }

emptyFixture :: Fixture m
emptyFixture = Fixture
  {  _findUsers = const unimplemented
  ,  _newSession = const unimplemented
  , _findUserBySession = const unimplemented
  }

newtype App a = App
  { unApp :: ReaderT (Fixture IO) IO a
  } deriving ( Applicative, Functor, Monad, MonadReader (Fixture IO), MonadIO
             )


runApp :: Fixture IO -> App a -> IO a
runApp fixture action = do
  flip runReaderT fixture . unApp $ action 
      
spec :: Spec
spec = do
        let time = ( Prelude.read "2011-11-19 18:28:52.607875 UTC" ) :: UTCTime
        let user = User 25 "Artem" "Kergakov" "dd" "qwerty" "avatar" time True True 
        describe "Logining" $ do
                it "should return user if right login and password" $ do
                        tvar <- newTVarIO Nothing
                        let fixture = emptyFixture { _findUsers = \"dd" "qwerty"-> do
                            atomically . writeTVar tvar $ Just (user)
                            return $ Right user}
                        runApp fixture (findUsers "dd" "qwerty") `shouldReturn` Right user
                        readTVarIO tvar `shouldReturn` Just (user)

                it "should return failure if password and login wrong" $ do
                        let fixture = emptyFixture { _findUsers = \_ _ -> return $ Left LoginErrorInvalidAuth }
                        runApp fixture (findUsers "ddss" "qwerty") `shouldReturn` Left LoginErrorInvalidAuth
        describe "Session" $ do
                it "should create new session if the login is successful" $ do
                        
                        let fixture = emptyFixture { _findUsers = \"dd" "qwerty"-> do
                            return $ Right user,
                            _newSession = \user -> if (id_user user) == 25 then return (SessionId "sId") else unimplemented }
            
                        runApp fixture (newSession user) `shouldReturn` (SessionId "sId")

        describe "Get User by session" $ do
                it "should return Nothing if the user is not found" $ do
                        let fixture = emptyFixture { _findUserBySession = \_ -> do
                            return $ Left UserErrorFindBySession}
                        runApp fixture (findUserBySession (SessionId "erd")) `shouldReturn` Left UserErrorFindBySession


                it "should return UserId if the session is found" $ do
                        let fixture = emptyFixture { _findUserBySession = \sId -> if sId == (SessionId "sId") then return (Right user) else unimplemented}
                        runApp fixture (findUserBySession (SessionId "sId")) `shouldReturn` Right user