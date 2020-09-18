module Adapter.HTTP.API.CommonService where

import Adapter.HTTP.Common
import ClassyPrelude
import Data.Aeson ()
import Domain.ImportEntity
import Domain.ImportService
import Network.HTTP.Types.Status
import qualified Prelude
import Web.Scotty.Trans

routes :: (ScottyError e, MonadIO m, CommonService m) => ScottyT e m ()
routes = do
  get "/api/getOne/:entity/:idE" $ do
    authResult <- getCookie "sId"
    case authResult of
      Nothing -> do
        status status400
        Web.Scotty.Trans.json ("not verification" :: Text)
      Just sess -> do
        print sess
        entity :: Text <- param "entity"
        idE :: Text <- param "idE"
        getResult <-
          lift $
          getOne
            (SessionId sess)
            entity
            (Prelude.read (ClassyPrelude.unpack idE) :: Int)
        case getResult of
          Left err -> do
            status status400
            print $ errorString err
          Right (EntAuthor author) -> do
            Web.Scotty.Trans.json author
          Right (EntCategory (CatCategory1 cat1)) -> do
            Web.Scotty.Trans.json cat1
          Right (EntCategory (CatCategory2 cat2)) -> do
            Web.Scotty.Trans.json cat2
          Right (EntCategory (CatCategory3 cat3)) -> do
            Web.Scotty.Trans.json cat3
          Right (EntComment com) -> do
            Web.Scotty.Trans.json com
          Right (EntDraft draf) -> do
            Web.Scotty.Trans.json draf
          Right (EntNews news) -> do
            Web.Scotty.Trans.json news
          Right (EntUser user) -> do
            Web.Scotty.Trans.json user
          Right (EntTeg teg) -> do
            Web.Scotty.Trans.json teg
  get "/api/getAll/:entity" $ do
    authResult <- getCookie "sId"
    case authResult of
      Nothing -> do
        status status400
        Web.Scotty.Trans.json ("not verification" :: Text)
      Just sess -> do
        print sess
        entity :: Text <- param "entity"
        getResult <- lift $ getAll (SessionId sess) entity
        case getResult of
          Left err -> do
            status status400
            print $ errorString err
          Right ent -> do
            case entity of
              "authors" ->
                Web.Scotty.Trans.json (convertFromEntityArray ent :: [Author])
              "users" ->
                Web.Scotty.Trans.json (convertFromEntityArray ent :: [User])
              "tags" ->
                Web.Scotty.Trans.json (convertFromEntityArray ent :: [Teg])
              "news" ->
                Web.Scotty.Trans.json (convertFromEntityArray ent :: [News])
              "categorys1" ->
                Web.Scotty.Trans.json
                  (convertFromCatEntArray $ convertFromEntityArray ent :: [Category1])
              "categorys2" ->
                Web.Scotty.Trans.json
                  (convertFromCatEntArray $ convertFromEntityArray ent :: [Category2])
              "categorys3" ->
                Web.Scotty.Trans.json
                  (convertFromCatEntArray $ convertFromEntityArray ent :: [Category3])
              "drafts" ->
                Web.Scotty.Trans.json (convertFromEntityArray ent :: [Draft])
              "comments" ->
                Web.Scotty.Trans.json (convertFromEntityArray ent :: [Comment])
  post "/api/create/:entity" $ do
    authResult <- getCookie "sId"
    case authResult of
      Nothing -> do
        status status400
        Web.Scotty.Trans.json ("not verification" :: Text)
      Just sess -> do
        entityText :: Text <- param "entity"
        entityMaybe <- funcGetMaybeEntity entityText
        case entityMaybe of
          Nothing -> do
            status status400
            Web.Scotty.Trans.json ("can't decode post information" :: Text)
          Just ent -> do
            resultCreate <- lift $ create (SessionId sess) ent
            case resultCreate of
              Left err -> do
                status status400
                print $ errorString err
              Right () -> do
                status status200
                print "Create success!!"
  put "/api/put/:entity" $ do
    authResult <- getCookie "sId"
    case authResult of
      Nothing -> do
        status status400
        Web.Scotty.Trans.json ("not verification" :: Text)
      Just sess -> do
        entityText :: Text <- param "entity"
        entityMaybe <- funcGetMaybeEntity entityText
        case entityMaybe of
          Nothing -> do
            status status400
            Web.Scotty.Trans.json ("can't decode post information" :: Text)
          Just ent -> do
            resultCreate <- lift $ editing (SessionId sess) ent
            case resultCreate of
              Left err -> do
                status status400
                print $ errorString err
              Right () -> do
                status status200
                print "Put success!!"
  Web.Scotty.Trans.delete "/api/delete/:entity/:ide" $ do
    authResult <- getCookie "sId"
    case authResult of
      Nothing -> do
        status status400
        Web.Scotty.Trans.json ("not verification" :: Text)
      Just sess -> do
        entityText :: Text <- param "entity"
        entityId :: Text <- param "ide"
        resultRemove <-
          lift $
          remove
            (SessionId sess)
            entityText
            (Prelude.read (ClassyPrelude.unpack entityId) :: Int)
        case resultRemove of
          Left err -> do
            status status400
            print $ errorString err
          Right () -> do
            status status200
            print "Delete  success!!"
  get "/api/update/:idE" $ do
    authResult <- getCookie "sId"
    case authResult of
      Nothing -> do
        status status400
        Web.Scotty.Trans.json ("not verification" :: Text)
      Just sess -> do
        draftId :: Text <- param "idE"
        resultUpdeit <-
          lift $
          update
            (SessionId sess)
            (Prelude.read (ClassyPrelude.unpack draftId) :: Int)
        case resultUpdeit of
          Left err -> do
            status status400
            print $ errorString err
          Right () -> do
            status status200
            print "Upgreid  success!!"

funcGetMaybeEntity ::
     (ScottyError e, MonadIO m, CommonService m)
  => Text
  -> ActionT e m (Maybe Entity)
funcGetMaybeEntity txt
  | txt == "author" = do
    b <- body
    let result :: Maybe Author = decode b
    return $
      case result of
        Nothing -> Nothing
        Just auth -> Just (convertToEntity auth)
  | txt == "category1" = do
    b <- body
    let result :: Maybe Category1 = decode b
    return $
      case result of
        Nothing -> Nothing
        Just auth -> Just (convertToEntity $ convertToCategory auth)
  | txt == "category2" = do
    b <- body
    let result :: Maybe Category2 = decode b
    return $
      case result of
        Nothing -> Nothing
        Just auth -> Just (convertToEntity $ convertToCategory auth)
  | txt == "category3" = do
    b <- body
    let result :: Maybe Category3 = decode b
    return $
      case result of
        Nothing -> Nothing
        Just auth -> Just (convertToEntity $ convertToCategory auth)
  | txt == "user" = do
    b <- body
    let result :: Maybe User = decode b
    return $
      case result of
        Nothing -> Nothing
        Just auth -> Just (convertToEntity auth)
  | txt == "teg" = do
    b <- body
    let result :: Maybe Teg = decode b
    return $
      case result of
        Nothing -> Nothing
        Just auth -> Just (convertToEntity auth)
  | txt == "comment" = do
    b <- body
    let result :: Maybe Comment = decode b
    return $
      case result of
        Nothing -> Nothing
        Just auth -> Just (convertToEntity auth)
  | txt == "draft" = do
    b <- body
    let result :: Maybe Draft = decode b
    return $
      case result of
        Nothing -> Nothing
        Just auth -> Just (convertToEntity auth)
  | txt == "news" = do
    b <- body
    let result :: Maybe News = decode b
    return $
      case result of
        Nothing -> Nothing
        Just auth -> Just (convertToEntity auth)
                        -- getResult <- lift $ create (SessionId sess) entity
                        --                             case getResult of
                        --                                 Left err -> do
                        --                                         status status400
                        --                                         print $ errorString err
                        --                                 Right ent -> do
                        --                                     case entity of
                        --                                         "authors" -> Web.Scotty.Trans.json ((convertFromEntityArray ent) :: [Author])
