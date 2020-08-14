module Adapter.HTTP.Common where

import ClassyPrelude
import Web.Scotty.Trans
import Blaze.ByteString.Builder (toLazyByteString)
import Web.Cookie
import Data.Time.Lens


import Domain.ImportEntity as E
import Domain.ImportService as S

setCookie :: (ScottyError e, Monad m) => SetCookie -> ActionT e m ()
setCookie = setHeader "Set-Cookie" . decodeUtf8 . toLazyByteString . renderSetCookie

getCookie :: (ScottyError e, Monad m) => Text -> ActionT e m (Maybe Text)
getCookie key = do
  mCookieStr <- header "Cookie"
  return $ do
    cookie <- parseCookies . encodeUtf8 . toStrict <$> mCookieStr
    let bsKey = encodeUtf8 key
    val <- lookup bsKey cookie
    return $ decodeUtf8 val



setSessionIdInCookie :: (MonadIO m, ScottyError e) => SessionId -> ActionT e m ()
setSessionIdInCookie sId = do
  curTime <- liftIO getCurrentTime
  setCookie $ def { setCookieName = "sId"
                  , setCookiePath = Just "/"
                  , setCookieValue = encodeUtf8  (rawSession sId)
                  , setCookieExpires = Just $ modL month (+ 1) curTime
                  , setCookieHttpOnly = True
                  , setCookieSecure = False
                  , setCookieSameSite = Just sameSiteLax
                  }



                  
-- getCurrentUserId :: (S.SessionRepo m, ScottyError e) => ActionT e m (Maybe UserId)
-- getCurrentUserId = do
--   -- let err :: Text = "Error of Get SessionId"
--   maySessionId <- getCookie "sId"
--   case maySessionId of
--     Nothing -> return Nothing
--     Just sId -> do
--       let newsId = mkSessionId sId
--       case newsId of
--         Left      _ -> return Nothing
--         Right  x    ->  lift $ (resolveSessionId x)
--         -- newsId <- lift $