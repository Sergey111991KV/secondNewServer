module Adapter.PostgreSQL.Auth.Auth where

import Domain.ImportEntity 
import ClassyPrelude
import  Adapter.PostgreSQL.Common
import Text.StringRandom
import qualified Logging.ImportLogging as Log
 


findUsers :: PG r m  => Text -> Text -> m (Either Error User)
findUsers pas log = do 
        let q = "SELECT * FROM user_blog where password = (?) and login = (?)"
        i <- (withConn $ \conn -> query conn q (pas, log ) :: IO [User]) 
        case i of
                [x]     -> do
                    Log.logIn Log.Debug $ "findUsers " ++ (entityToText  x) -- log
                    return $  Right  x
                       
                []      -> do
                    Log.logIn Log.Error $ "Error findUsers " ++ (errorText DataErrorPostgreSQL)  -- log
                    return $  Left DataErrorPostgreSQL


newSession :: PG r m  => User -> m SessionId
newSession us = do 
    deleteOldSession us
    insertNewSession us
    result <- withConn $ \conn -> query conn qry [(id_user us)]
    case result of
        [sId] -> do
            Log.logIn Log.Debug (entityToText  us) -- log
            return sId
        err -> do
            Log.logIn Log.Error "Error newSession"  -- log
            throwString $ "Unexpected error: " <> show err
    where
        qry = "select key from session where user_id= ?"


deleteOldSession :: PG r m
                => User  -> m Int64 
deleteOldSession us  = do
        result <- withConn $ \conn -> execute conn qry [(id_user us)]
        return result 
        where
            qry = "delete from session where user_id = ?"







insertNewSession :: PG r m
                => User  -> m Int64 
insertNewSession  us  = do
    sId <- liftIO $ stringRandomIO "[a-zA-Z0-9]{32}"
    result <- withConn $ \conn -> execute conn qry (sId , (id_user us))
    return result 
    where
        qry = "INSERT INTO session (key ,user_id) values (?,?)"     



findUserBySession :: PG r m  => SessionId -> m (Either Error User)
findUserBySession sesId = do
        i <- findUserIdBySessionId sesId
        case i of
                Right uIdStr     -> do
                        let q = "SELECT * FROM user_blog where id_user = (?)"
                        i <- (withConn $ \conn -> query conn q [uIdStr] :: IO [User]) 
                        case i of
                                [y]     ->  do
                                        Log.logIn Log.Debug $ "findUserBySession " ++ (entityToText  y) -- log
                                        return $ Right  y
                                       
                                []      ->  do
                                        Log.logIn Log.Error $ "Error findUserBySession " ++ (errorText DataErrorPostgreSQL)  -- log
                                        return $ Left DataErrorPostgreSQL
                       
                Left err      -> return $ Left err

findUserIdBySessionId      :: PG r m => SessionId ->  m (Either Error UserId) 
findUserIdBySessionId sesId = do

        result <- withConn $ \conn -> query conn qry (sesId)
        return $ case result of
            [uIdStr] -> Right uIdStr
            _        -> Left DataErrorPostgreSQL
        where
          qry = "select user_id from session where key = ? "