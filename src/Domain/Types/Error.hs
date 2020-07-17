module Domain.Types.Error where

import Domain.Types.Imports


data Error =  AccessError 
            | LoginErrorInvalidAuth 
            | NotResearch 
            | DataErrorPostgreSQL deriving (Eq, Ord, Read, Show, Generic)

errorString :: Error ->  String
errorString err 
        | err == AccessError              =  "AccessError"
        | err == LoginErrorInvalidAuth              =  "LoginErrorInvalidAuth"
        | err == NotResearch =  "NotResearch"
        | err == DataErrorPostgreSQL = "DataErrorPostgreSQL"