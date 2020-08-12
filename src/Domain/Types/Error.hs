module Domain.Types.Error where

import Domain.Types.Imports
import ClassyPrelude


data Error =  AccessError 
            | LoginErrorInvalidAuth 
            | NotResearch 
            | DataErrorPostgreSQL
            | AccessErrorAdmin
            | AccessErrorAuthor
            | UserErrorFindBySession deriving (Eq, Ord, Read, Show, Generic)

errorString :: Error ->  String
errorString err 
        | err == AccessError              =  "AccessError"
        | err == LoginErrorInvalidAuth              =  "LoginErrorInvalidAuth"
        | err == NotResearch =  "NotResearch"
        | err == DataErrorPostgreSQL = "DataErrorPostgreSQL"
        | err == AccessErrorAdmin = "AccessErrorAdmin"
        | err == AccessErrorAuthor = "AccessErrorAuthor"
        | err == UserErrorFindBySession = "UserErrorFindBySession"