module Domain.Types.Error where

import Domain.Types.Imports


data Error = AccessError | DataError | LoginErrorInvalidAuth | NotResearch deriving (Eq, Ord, Read, Show, Generic)