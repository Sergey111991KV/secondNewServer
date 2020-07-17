module Adapter.PostgreSQL.CommonService where



import  Domain.ImportEntity 
import  Adapter.PostgreSQL.Common

getAll :: PG r m => Bool -> Text -> m (Either Error [Entity])
getAll access text  
                | text == "authors"     = do
                    let q = "SELECT * FROM author"
                    result <- (withConn $ \conn -> query_ conn q  :: IO [Author'])
                    case result of
                            [ ]             ->  return $ Left DataErrorPostgreSQL
                            authors'            -> do
                                    newResult <- convertToAuthorArray authors'
                                    return $ case newResult of
                                        Left err    ->  Left err
                                        Right auth  ->  Right auth
                | text == "users"       = do
                    let q = "SELECT * FROM user_blog"
                    result <- (withConn $ \conn -> query_ conn q  :: IO [User])
                    let newResult = fmap convertToEntity result
                    case newResult of
                            [ ]             ->  return $ Left DataErrorPostgreSQL
                            newResult       ->  return $ Right newResult   
                | text == "tegs"        = do
                    let q = "SELECT * FROM tags"
                    result <- (withConn $ \conn -> query_ conn q  :: IO [Teg])
                    let newResult = fmap convertToEntity result
                    case newResult of
                            [ ]             ->  return $ Left DataErrorPostgreSQL
                            newResult       ->  return $ Right newResult   
                | text == "news"        = do 
                    let q = "SELECT * FROM news"
                    result <- (withConn $ \conn -> query_ conn q  :: IO [News'])
                    case result of
                        [ ]             ->  return $ Left DataErrorPostgreSQL
                        news'            -> do
                                newResult <- convertToNewsArray news'
                                return $ case newResult of
                                    Left err    ->  Left err
                                    Right news  ->  Right news
                | text == "categorys1"  = do 
                    let q = "SELECT * FROM category_1"
                    result <- (withConn $ \conn -> query_ conn q  :: IO [Category1'])
                    case result of
                        [ ]             ->  return $ Left DataErrorPostgreSQL
                        result            -> do
                                newResult <- convertToCategoryPostgressArray result
                                return $ case newResult of
                                    Left err    ->  Left err
                                    Right cat  ->  Right cat
                | text == "categorys2"  = undefined
                | text == "categorys3"  = undefined
                | text == "drafts"  = undefined
                | text == "comments"  = undefined
                

                

                                
getArrayFromNews :: PG r m => Int -> Text -> m (Either Error [Entity]) 
getArrayFromNews = undefined


getOne :: PG r m => Bool -> Text -> Int ->  m (Either Error  Entity)
getOne access text idE
                    | text == "news" = do
                        let q = "SELECT * FROM news where id = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [News'])
                        case i of
                                [x]     -> convertToNews x

                                []      -> return $ Left DataErrorPostgreSQL
                    | text == "author" = do
                        let q = "SELECT * FROM author where id = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [Author']) 
                        case i of
                                [x]     -> convertToAuthor x

                                []      -> return $ Left DataErrorPostgreSQL

                    | text == "category1" = do
                        let q = "SELECT * FROM category_1 where id = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [Category1']) 
                        case i of
                                [x]     -> convertToCategoryPostgress (CatCategory1' x)

                                []      -> return $ Left DataErrorPostgreSQL
                    | text == "category2" = do
                        let q = "SELECT * FROM category_2 where id = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [Category2']) 
                        case i of
                                [x]     -> convertToCategoryPostgress (CatCategory2' x)

                                []      -> return $ Left DataErrorPostgreSQL
                    | text == "category3" = do
                        let q = "SELECT * FROM category_3 where id = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [Category3']) 
                        case i of
                                [x]     -> convertToCategoryPostgress (CatCategory3' x)

                                []      -> return $ Left DataErrorPostgreSQL
                    | text == "draft" = do
                        let q = "SELECT * FROM drafts where id = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [Draft]) 
                        return $ case i of
                                [x]     -> Right $ convertToEntity x 
                                       
                                []      -> Left DataErrorPostgreSQL

                    | text == "comment" = do
                        let q = "SELECT * FROM comments where id = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [Comment]) 
                        return $ case i of
                                [x]     -> Right $ convertToEntity x 
                                       
                                []      -> Left DataErrorPostgreSQL

                    | text == "teg" = do
                        let q = "SELECT * FROM drafts where id = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [Teg]) 
                        return $ case i of
                                [x]     -> Right (convertToEntity x) 
                                       
                                []      -> Left DataErrorPostgreSQL
                    | text == "user" = do
                        let q = "SELECT * FROM drafts where id = (?)"
                        i <- (withConn $ \conn -> query conn q [idE] :: IO [User]) 
                        return $ case i of
                                [x]     -> Right (convertToEntity x) 
                                       
                                []      -> Left DataErrorPostgreSQL
                                        
convertToAuthorArray  :: PG r m =>  [Author'] -> m (Either Error [Entity])
convertToAuthorArray =  undefined

convertToAuthor :: PG r m =>  Author' -> m (Either Error Entity)
convertToAuthor = undefined 

convertToCategoryPostgress :: PG r m =>  Category' -> m (Either Error Entity)
convertToCategoryPostgress = undefined

convertToCategoryPostgressArray :: PG r m =>  [Category'] -> m (Either Error [Entity])
convertToCategoryPostgressArray = undefined 

convertToNewsArray :: PG r m =>  [News'] -> m (Either Error [Entity])
convertToNewsArray =  undefined

convertToNews :: PG r m =>  News' -> m (Either Error Entity)
convertToNews (News' iD date auth cat3 textN mainP otherP shtNam) = do
        a <- getOne True  "author" auth
        case a of
            Left err -> return $ Left err
            Right (EntAuthor author) -> do
                cat <- getOne True  "category1" cat3
                case cat of
                    Left err -> return $ Left err
                    Right (EntCategory (CatCategory1 category)) -> do
                        d <- getArrayFromNews iD  "drafts"
                        case d of
                            Left err -> return $ Left err
                            Right [EntDraft drafts] -> do 
                                c <- getArrayFromNews iD  "comments" 
                                case c of
                                    Left err -> return $ Left err
                                    Right [EntComment comments] -> do 
                                        t <- getArrayFromNews iD  "tegs"
                                        case t of
                                            Left err -> return $ Left err
                                            Right [EntTeg tegs] -> do 
                                                return $ Right $ EntNews (News iD date author category textN mainP otherP shtNam [drafts] [comments] [tegs])

--         categoris <-  getCategory1 cat3
--         draft <- getAll true "tegs"
--         News iD date  textN mainP otherP shtNam 


-- convertAuthor :: PG r m =>  Author' -> m (Either Error Author) 
-- convertAuthor = undefined

-- getCategory1   :: PG r m =>  Int -> m (Either Error Category1) 
-- getCategory1 = undefined
-- let qAuthor = "SELECT * FROM author where id = (?)"
-- iAuthor <- (withConn $ \conn -> query conn q [authors_id_news' x] :: IO [News'])
                                            -- id_news'               :: Int,
                                            -- data_create_news'      :: UTCTime,
                                            -- authors_id_news'       :: Int,
                                            -- category_3_id_news'    :: Int,
                                            -- text_news'             :: Text,
                                            -- main_photo_url_news'   :: Text,
                                            -- other_photo_url_news'  :: PGArray Text,
                                            -- short_name_news'       :: Text


                                            -- id_news               :: Int,
                                            -- data_create_news      :: UTCTime,
                                            -- authors               :: Author,
                                            -- category              :: Category1,
                                            -- text_news             :: Text,
                                            -- main_photo_url_news   :: Text,
                                            -- other_photo_url_news  :: PGArray Text,
                                            -- short_name_news       :: Text,
                                            -- drafts                :: [Draft]
                                            -- comments              :: [Comment],
                                            -- tegs                  :: [Teg]