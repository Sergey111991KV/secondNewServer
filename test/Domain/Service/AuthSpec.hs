module Domain.Service.AuthSpec where

import ClassyPrelude
import Test.Hspec
import Fixture
import Domain.ImportService
import Domain.ImportEntity 

data Fixture m = Fixture {
    _findUsers                   :: Text -> Text -> m (Either Error User) 
    _newSession                  :: User -> m SessionId
    _findUserBySession           :: SessionId -> m (Either Error User)
}

unimplemented :: a
unimplemented = error "unimplemented"

emptyFixture :: Fixture m
emptyFixture = Fixture {
    _findUsers                    = const unimplemented
    _newSession                   = const unimplemented
    _findUserBySession            = const unimplemented
    }

newtype App a = App
  { unApp :: ReaderT (Fixture IO)  a
  } deriving ( Applicative, Functor, Monad, MonadReader (Fixture IO), MonadIO)


dispatch :: (MonadIO m, MonadReader r m)
         => (r -> a -> IO b)
         -> (a -> m b)
dispatch getter param = do
  func <- asks getter
  liftIO $ func param
dispatch2 :: (MonadIO m, MonadReader r m)
          => (r -> a -> b -> IO c)
          -> (a -> b -> m c)
dispatch2 getter param1 param2 = do
  func <- asks getter
  liftIO $ func param1 param2

instance Auth App where
        findUsers                  = dispatch2 _findUsers
        newSession                  = dispatch _newSession
        findUserBySession           = dispatch _findUserBySession


runApp :: Fixture IO -> App a -> IO a
runApp fixture action = do
    flip runReaderT fixture . unApp $ action


