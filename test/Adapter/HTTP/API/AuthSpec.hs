module Adapter.HTTP.API.AuthSpec where

import ClassyPrelude
import Test.Hspec hiding (pending)
import Test.Hspec.Wai
import Test.Hspec.Wai.JSON
import Network.HTTP.Types
import Data.Time 
import Adapter.HTTP.Fixture
import qualified Prelude as Prelude

import Network.HTTP.Types.Status
-- import Data.Aeson ()

import Domain.ImportEntity 
import Adapter.HTTP.API.Auth
import Adapter.HTTP.Common


spec :: Spec
spec = do
    let time = ( Prelude.read "2011-11-19 18:28:52.607875 UTC" ) :: UTCTime
    let user = User 1 "Pasha" "Kergakov" "pasha@test.com" "3456ABCDefgh" "avatar" time True True 
    describe "GET /api/auth/:password/:login if login and password wrong" $ do
            -- let fixture = emptyFixture { _findUsers = \_ _ -> return $ Left LoginErrorInvalidAuth }
        let wrongTakenFixture = emptyFixture { _findUsers = \_ _  -> return $  Left DataErrorPostgreSQL }
        with (app wrongTakenFixture ) $ do
            it "should not return user " $  
                get "/api/auth/wwww/wwww"  `shouldRespondWith` 400 
    -- describe "GET /api/auth/:password/:login if login and password true" $ do
    --     let rightTakenFixture = emptyFixture { _findUsers = \"3456ABCDefgh" "pasha@test.com"  -> return $  Right user }
    --     with (app rightTakenFixture ) $ do
    --         it "should return user as login and password true" $ 
    --             get "/api/auth/3456ABCDefgh/pasha@test.com"  `shouldRespondWith` 200 
            
                     


-- import Text.StringRandom
-- import Logging.LogMonad
-- import Logging.Logging
-- import qualified Config as Config


-- type Path = ByteString
-- type Body = ByteString
-- get, options, delete :: Path -> WaiSession SResponse
-- post, put, patch :: Path -> Body -> WaiSession SResponse