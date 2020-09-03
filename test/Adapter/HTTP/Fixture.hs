module Adapter.HTTP.Fixture where
import ClassyPrelude

import Network.Wai
import qualified Adapter.HTTP.Main as HTTP
import Fixture
import Domain.ImportEntity
import Domain.ImportService 
import Fixture 
import Test.Hspec


data Fixture m = Fixture
  {  _findUsers                   :: Text -> Text -> m (Either Error User) -- password login
  ,  _newSession                  :: User -> m SessionId
  ,  _findUserBySession           :: SessionId -> m (Either Error User)
  }

emptyFixture :: Fixture IO
emptyFixture = Fixture
    {  _findUsers                   = \_ _ -> unimplemented
    ,  _newSession                  = const unimplemented
    ,  _findUserBySession           = const unimplemented
    }

 
newtype App a = App
  { unApp :: ReaderT (Fixture IO)  IO a
  } deriving ( Applicative, Functor, Monad, MonadReader (Fixture IO), MonadIO)

app :: Fixture IO -> IO Application
app fixture = do
  let runner = flip runReaderT fixture . unApp
  HTTP.app runner

instance Auth App where
        findUsers = dispatch2 _findUsers
        newSession = dispatch _newSession
        findUserBySession = dispatch _findUserBySession

instance FilterService App where

instance CommonService App where

instance SortedOfService App where
  