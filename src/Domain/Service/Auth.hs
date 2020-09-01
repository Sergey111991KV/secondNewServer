module Domain.Service.Auth where


import  Domain.ImportEntity 
import  ClassyPrelude


class (Monad m) => Auth m where
    findUsers                   :: Text -> Text -> m (Either Error User) -- password login
    newSession                  :: User -> m SessionId
    findUserBySession           :: SessionId -> m (Either Error User)
   