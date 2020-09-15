module Adapter.HTTP.API.FilterService where

import ClassyPrelude
import Web.Scotty.Trans
import Network.HTTP.Types.Status
import Data.Aeson ()
import Adapter.HTTP.Common
import Domain.ImportService
import Domain.ImportEntity
import qualified Prelude



routes :: ( ScottyError e, MonadIO m, FilterService m)
          => ScottyT e m ()
routes = do
        get "/api/news/filterOfData/:time/:condition" $ do
                time   :: Text   <-      param "time" 
                condition   :: Text   <-      param "condition" 
                getResult <- lift $ filterOfData (ClassyPrelude.unpack time) (ClassyPrelude.unpack condition)
                case getResult of
                    Left err -> do
                        status status400
                        print $ errorString err
                    Right news -> do
                        Web.Scotty.Trans.json news

        get "/api/news/filterAuthor/:name" $ do
                name   :: Text   <-      param "name" 
                getResult <- lift $ filterAuthor (ClassyPrelude.unpack name)
                case getResult of
                    Left err -> do
                        status status400
                        print $ errorString err
                    Right news -> do
                        Web.Scotty.Trans.json news

        get "/api/news/filterCategory/:idCat" $ do
                idCat   :: Text   <-      param "idCat"  
                getResult <- lift $ filterCategory (Prelude.read (ClassyPrelude.unpack idCat) :: Int)
                case getResult of
                    Left err -> do
                        status status400
                        print $ errorString err
                    Right news -> do
                        Web.Scotty.Trans.json news

        get "/api/news/filterTeg/:idTeg" $ do
                idTeg   :: Text   <-      param "idTeg" 
                getResult <- lift $ filterTeg  (Prelude.read (ClassyPrelude.unpack idTeg) :: Int)
                case getResult of
                    Left err -> do
                        status status400
                        print $ errorString err
                    Right news -> do
                        Web.Scotty.Trans.json news

        get "/api/news/filterOneOfTegs/:idTegs" $ do
                idTegs   :: Text   <-      param "idTegs" 
                getResult <- lift $ filterOneOfTegs  (Prelude.read (ClassyPrelude.unpack idTegs) :: [Int])
                case getResult of
                    Left err -> do
                        status status400
                        print $ errorString err
                    Right news -> do
                        Web.Scotty.Trans.json news

        get "/api/news/filterAllOfTegs/:idTegs" $ do
                idTegs   :: Text   <-      param "idTegs" 
                getResult <- lift $ filterAllOfTegs  (Prelude.read (ClassyPrelude.unpack idTegs) :: [Int])
                case getResult of
                    Left err -> do
                        status status400
                        print $ errorString err
                    Right news -> do
                        Web.Scotty.Trans.json news

        get "/api/news/filterName/:param" $ do
                txt   :: Text   <-      param "param" 
                getResult <- lift $ filterName (ClassyPrelude.unpack txt) 
                case getResult of
                    Left err -> do
                        status status400
                        print $ errorString err
                    Right news -> do
                        Web.Scotty.Trans.json news

        get "/api/news/filterContent/:param" $ do
                txt   :: Text   <-      param "param" 
                getResult <- lift $ filterContent  (ClassyPrelude.unpack txt)
                case getResult of
                    Left err -> do
                        status status400
                        print $ errorString err
                    Right news -> do
                        Web.Scotty.Trans.json news