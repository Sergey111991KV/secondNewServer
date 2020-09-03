module Adapter.PostgreSQL.Auth.Auth where

import Domain.ImportEntity 
import ClassyPrelude
import  Adapter.PostgreSQL.Common
import Text.StringRandom
import Logging.ImportLogging as L
 


findUsers :: PG r m  => Text -> Text -> m (Either Error User)
findUsers pas log = do 
        let q = "SELECT * FROM user_blog where password = (?) and login = (?)"
        i <- (withConn $ \conn -> query conn q (pas, log ) :: IO [User]) 
        return $ case i of
                [x]     -> Right  x
                       
                []      -> Left DataErrorPostgreSQL


newSession :: PG r m  => User -> m SessionId
newSession us = do 
    deleteOldSession us
    insertNewSession us
    result <- withConn $ \conn -> query conn qry [(id_user us)]
    case result of
        [sId] -> do
            logIn Debug (entityToText  us) -- logggg)))
            return sId
        err -> do
            logIn L.Error "Error newSession"
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
                        return $ case i of
                                [y]     ->  Right  y
                                       
                                []      ->  Left DataErrorPostgreSQL
                       
                Left err      -> return $ Left err

findUserIdBySessionId      :: PG r m => SessionId ->  m (Either Error UserId) 
findUserIdBySessionId sesId = do

        result <- withConn $ \conn -> query conn qry (sesId)
        return $ case result of
            [uIdStr] -> Right uIdStr
            _        -> Left DataErrorPostgreSQL
        where
          qry = "select user_id from session where key = ? "