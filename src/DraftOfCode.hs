module DraftOfCode where

                -- Postgress
-- "SELECT n.id_news, \
--                                     \ n.data_create_n, \
--                                     \ n.id_author, n.description_author, n.id_user, n.name_user, n.last_name_user, n.login, n.password, n.avatar, n.data_create_u, n.admini, n.author , \
--                                     \ n.id_c3, n.description_cat3, n.id_c2, n.description_cat2, n.id_c1, n.description_cat1 , \
--                                     \ n.description_news , \
--                                     \ n.main_photo_url_n , \
--                                     \ ARRAY ( SELECT n.other_photo_url_n FROM n) , \
--                                     \ n.short_name_n \
--                                     \ , ARRAY (SELECT row ((elements_draft).id_draft, (elements_draft).text_draft , (elements_draft).data_create_draft , (elements_draft).news_id_draft , (elements_draft).main_photo_url , (elements_draft).other_photo_url , (elements_draft).short_name  ) FROM drafts where (elements_draft).news_id = news.id ) \
--                                     \ , ARRAY(SELECT ROW ((element_comment).id_comments, (element_comment).text_comments , (element_comment).data_create_comments , (element_comment).news_id_comments , (element_comment).users_id_comments) FROM comments where (element_comment).news_id_comments = news.id ) \
--                                     \ , ARRAY(SELECT ROW ((element_tags).id_teg, (element_tags).name_teg) FROM tags where (element_tags).id_teg  = news.id ) \
--                                     \ from (news LEFT join ( SELECT * from author LEFT join user_blog USING (id_user)) AS a ON news.id_news = a.id_user) as n LEFT join (SELECT * from category_1 LEFT join (SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id_c2) as c2 on category_1.id_c1 = c2.category_1_id) as cat on n.category_3_id = cat.id_c3 \
--                                     \ where n.id = (?)"

                                    -- SELECT * from category_1 LEFT join (SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id_c2) as c2 on category_1.id_c1 = c2.category_1_id



    

    -- - 9.4+ ARRAY constructor in correlated subquery
    -- SELECT tbl_id, ARRAY(SELECT json_array_elements_text(t.data->'tags')) AS txt_arr
    -- FROM   tbl t;
    -- SELECT ARRAY (SELECT comment_type
    

--     CREATE FUNCTION insert_json_comment(js_ json[]) RETURNS comment_type[] AS $$
-- DECLARE
--     x json;
--     new_el comment_type;
--     elements comment_type[];
-- BEGIN
--     FOREACH x  IN ARRAY js_
--     	LOOP
--           SELECT  * INTO new_el from json_populate_record(null::comment_type, x);
--            elements = array_append(new_el);
--         END LOOP;
--         RETURN elements;
--     END;
-- $$ LANGUAGE plpgsql;


-- CREATE FUNCTION insert_comment(comment_type[]) RETURNS void AS $$
-- DECLARE
--     x comment_type;
-- BEGIN
--     FOREACH x  IN ARRAY $1
--     	LOOP
--          UPDATE comments SET  element_comment.text_comments = x.text_comments 
--                                 , element_comment.data_create_comments = x.data_create_comments
--                                 , element_comment.news_id_comments = x.news_id_comments
--                                 , element_comment.users_id_comments = x.users_id_comments 
--                                    WHERE (element_comment).id_comments = x.id_comments ; \
--          END LOOP;
--     END;
-- $$ LANGUAGE plpgsql;

    -- SELECT news.id, news.data_create, author.id, author.description, user_blog.id_user, user_blog.name, user_blog.last_name, user_blog.login, user_blog.password, user_blog.avatar, user_blog.data_create, user_blog.admini, user_blog.author , category_3.id, category_3.description, category_2.id, category_2.description, category_1.id, category_1.description , news.description , news.main_photo_url , 
    -- ARRAY ( SELECT news.other_photo_url FROM news) , 
    -- news.short_name 
    -- , ARRAY(SELECT ROW (drafts.id , drafts.description , drafts.data_create , drafts.news_id , drafts.main_photo_url , drafts.other_photo_url , drafts.short_name  ) FROM drafts where drafts.news_id = news.id )
    -- , ARRAY(SELECT ROW (comments.id_comments, comments.text_comments , comments.data_create_comments , comments.news_id_comments , comments.users_id_comments) FROM comments where comments.news_id_comments = news.id ) 
    -- , ARRAY(SELECT ROW (tags.id, tags.name) FROM (news JOIN news_tags USING (id)) JOIN tags USING (id)) 
    -- FROM news , author , user_blog, category_3, category_2, category_1, drafts, comments, tags, news_tags where news.id = (?)
   
    --                                        \ FROM news , author , user_blog, category_3, category_2, category_1, drafts, comments, tags, news_tags  where news.id = (?)"




    --                                        "SELECT   news.id \
    --                                        \ , news.data_create \
    --                                        \ , author.id, author.description, user_blog.id_user, user_blog.name, user_blog.last_name, user_blog.login, user_blog.password, user_blog.avatar, user_blog.data_create, user_blog.admini, user_blog.author \
    --                                        \ , category_3.id, category_3.description, category_2.id, category_2.description, category_1.id, category_1.description \
    --                                        \ , news.description \
    --                                        \ , news.main_photo_url \
    --                                        \ , ARRAY (SELECT news.other_photo_url FROM news) \
    --                                        \ , news.short_name \
    --                                        \ , ARRAY(SELECT * FROM drafts where drafts.news_id = news.id ) \
    --                                        \ , ARRAY(SELECT * FROM comments where comment.news_id_comments = news.id ) \
    --                                        \ , ARRAY(SELECT tags.id, tags.name FROM (news JOIN news_tags USING (news.id)) JOIN tags USING (tags.id)) \
    --                                        \ FROM news , author , user_blog, category_3, category_2, category_1, drafts, comments, tags, news_tags  where news.id = (?)"
    
    
    -- SELECT * from (news LEFT join ( SELECT * from author LEFT join user_blog USING (id_user)) AS a ON news.id_news = a.id_user) as n LEFT join (SELECT * from category_1 LEFT join (SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id_c2) as c2 on category_1.id_c1 = c2.category_1_id) as cat on n.category_3_id = cat.id_c3
    -- SELECT * from author LEFT join user_blog ON author.user_id = user_blog.id_user;
    -- SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id
    -- SELECT * from category_1 LEFT join (SELECT * from category_3 LEFT join category_2 ON category_3.category_2_id = category_2.id) as c2 on category_1.id = c2.category_1_id


    -- ALTER TABLE category_3 RENAME COLUMN id TO id_c3;










--     CREATE TYPE drafts_type AS(
-- 	id_draft 				integer,
-- 	text_draft				text,
-- 	data_create_draft		timestamptz, 
-- 	news_id_draft			integer,
-- 	main_photo_url			text,
-- 	other_photo_url			text[],
-- 	short_name				text );
	
-- CREATE TYPE  comment_type AS(
-- 	id_comments 				integer,
-- 	text_comments				text,
-- 	data_create_comments		timestamptz, 
-- 	news_id_comments			integer,
-- 	users_id_comments			integer);
	
-- CREATE TYPE  teg_type AS(
-- 	id_teg 					integer,
-- 	name_teg				text);
	
-- -- DDL generated by Postico 1.5.10
-- -- Not all database features are supported. Do not use for backup.

-- -- Table Definition ----------------------------------------------

-- CREATE TABLE author (
--     id_author integer PRIMARY KEY,
--     description_author text,
--     id_user integer REFERENCES user_blog(id_user)
-- );

-- -- Indices -------------------------------------------------------

-- CREATE UNIQUE INDEX author_pkey ON author(id_author int4_ops);
-- -- DDL generated by Postico 1.5.10
-- -- Not all database features are supported. Do not use for backup.

-- -- Table Definition ----------------------------------------------

-- CREATE TABLE category_1 (
--     id_c1 integer DEFAULT nextval('category_1_id_seq'::regclass) PRIMARY KEY,
--     description_cat1 text
-- );

-- -- Indices -------------------------------------------------------

-- CREATE UNIQUE INDEX category_1_pkey ON category_1(id_c1 int4_ops);






-- testArrayTeg :: PG r m =>  m (Either Error TestArrayTeg)
-- testArrayTeg = do 
--                 let q = " SELECT ARRAY (SELECT * FROM tags)"
--                 result <- (withConn $ \conn -> query_ conn q  :: IO [TestArrayTeg]) 
--                 return $ case result of
--                         [ ]             ->  Left DataErrorPostgreSQL
--                         [teg]             ->  Right teg

-- testArrayComment :: PG r m =>  m (Either Error TestArrayComment)
-- testArrayComment = do 
--                 let q = " SELECT ARRAY (SELECT * FROM comments)"
--                 result <- (withConn $ \conn -> query_ conn q  :: IO [TestArrayComment]) 
--                 return $ case result of
--                         [ ]             ->  Left DataErrorPostgreSQL
--                         [teg]             ->  Right teg
-- testArrayDraft :: PG r m =>  m (Either Error TestArrayDraft)
-- testArrayDraft = do 
--                 let q = " SELECT ARRAY (SELECT * FROM drafts)"
--                 result <- (withConn $ \conn -> query_ conn q  :: IO [TestArrayDraft]) 
--                 return $ case result of
--                         [ ]             ->  Left DataErrorPostgreSQL
--                         [teg]             ->  Right teg





                          -- let q = "SELECT   (elements_draft).id_draft  \
                                                --         \ , (elements_draft).text_draft \
                                                --         \ , (elements_draft).data_create_draft \
                                                --         \ , (elements_draft).news_id_draft \
                                                --         \ , (elements_draft).main_photo_url \
                                                --         \ , (elements_draft).other_photo_url \
                                                --         \ , (elements_draft).short_name FROM drafts where ;"