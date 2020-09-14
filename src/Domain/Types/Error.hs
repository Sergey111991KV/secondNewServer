module Domain.Types.Error where

import Domain.Types.Imports
import ClassyPrelude


data Error =  AccessError 
            | LoginErrorInvalidAuth 
            | NotResearch 
            | NotResearchDraft
            | NotResearchAuthor
            | NotResearchNews
            | DataErrorPostgreSQL
            | AccessErrorAdmin
            | ErrorCommentToUser
            | AccessErrorAuthor
            | SQLExeptionError
            | UserErrorFindBySession deriving (Eq, Ord, Read, Show, Generic)

errorString :: Error ->  String
errorString err 
        | err == AccessError              =  "AccessError"
        | err == LoginErrorInvalidAuth              =  "LoginErrorInvalidAuth"
        | err == NotResearch =  "NotResearch"
        | err == NotResearchDraft =  "NotResearchDraft"
        | err == NotResearchAuthor =  "NotResearchAuthor"
        | err == NotResearchNews =  "NotResearchNews"
        | err == ErrorCommentToUser =  "ErrorCommentToUser"
        | err == DataErrorPostgreSQL = "DataErrorPostgreSQL"
        | err == AccessErrorAdmin = "AccessErrorAdmin"
        | err == AccessErrorAuthor = "AccessErrorAuthor"
        | err == SQLExeptionError = "SQLExeptionError"
        | err == UserErrorFindBySession = "UserErrorFindBySession"

errorText :: Error ->  Text
errorText err 
        | err == AccessError              =  "AccessError"
        | err == LoginErrorInvalidAuth              =  "LoginErrorInvalidAuth"
        | err == NotResearch =  "NotResearch"
        | err == NotResearchDraft =  "NotResearchDraft"
        | err == NotResearchAuthor =  "NotResearchAuthor"
        | err == NotResearchNews =  "NotResearchNews"
        | err == ErrorCommentToUser =  "ErrorCommentToUser"
        | err == DataErrorPostgreSQL = "DataErrorPostgreSQL"
        | err == AccessErrorAdmin = "AccessErrorAdmin"
        | err == AccessErrorAuthor = "AccessErrorAuthor"
        | err == SQLExeptionError = "SQLExeptionError"
        | err == UserErrorFindBySession = "UserErrorFindBySession"