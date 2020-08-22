module Adapter.Fixture where

import ClassyPrelude

import Network.Wai
import Fixture
import Domain.ImportService
import Domain.ImportEntity 



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
      