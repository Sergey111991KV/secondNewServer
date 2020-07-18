module Domain.Service.CommonService where


import  Domain.ImportEntity 
import ClassyPrelude


class Monad m =>  CommonService m  where
    create  :: Bool -> Entity  -> m (Either Error ())
    editing :: Bool -> Entity -> m (Either Error ())
    getAll  :: Bool -> Text -> m (Either Error [Entity])
    getOne  :: Bool -> Text -> Int ->  m (Either Error  Entity)
    remove  :: Bool -> Text -> Int ->  m (Either Error ())