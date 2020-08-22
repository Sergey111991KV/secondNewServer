module Domain.Service.CommonService where


import  Domain.ImportEntity 
import ClassyPrelude


class (Monad m) =>  CommonService m  where
    create  :: SessionId -> Entity  -> m (Either Error ())
    editing :: SessionId -> Entity -> m (Either Error ())
    getAll  :: SessionId -> Text -> m (Either Error [Entity])
    getOne  :: SessionId -> Text -> Int ->  m (Either Error  Entity)
    remove  :: SessionId -> Text -> Int ->  m (Either Error ())
    updeit  :: SessionId -> Int ->  m (Either Error ())