CREATE TYPE drafts_type AS(
	id_draft 				integer,
	text_draft				text,
	data_create_draft		timestamp with time zone , 
	news_id_draft			integer,
	main_photo_url			text,
	other_photo_url			text[],
	short_name				text );
	
CREATE TYPE  comment_type AS(
	id_comments 				integer,
	text_comments				text,
	data_create_comments		timestamp with time zone , 
	news_id_comments			integer,
	users_id_comments			integer);
	
CREATE TYPE  teg_type AS(
	id_teg 					integer,
	name_teg				text);
	
CREATE TABLE tags (
    element_tags teg_type PRIMARY KEY
);


CREATE TABLE comments (
    element_comment comment_type PRIMARY KEY
);


CREATE TABLE drafts (
    elements_draft drafts_type PRIMARY KEY
);

CREATE TABLE user_blog (
    id_user serial PRIMARY KEY,
    name_user text,
    last_name_user text,
    login text,
    password text,
    avatar text,
    data_create_u timestamp with time zone,
    admini boolean,
    author boolean
);


CREATE TABLE author (
    id_author serial PRIMARY KEY,
    description_author text,
    id_user integer REFERENCES user_blog(id_user)
);


CREATE TABLE category_1 (
    id_c1 serial  PRIMARY KEY,
    description_cat1 text
);


CREATE TABLE category_2 (
    id_c2 serial PRIMARY KEY,
    description_cat2 text,
    category_1_id integer REFERENCES category_1(id_c1) ON DELETE CASCADE
);



CREATE TABLE category_3 (
    id_c3 serial PRIMARY KEY,
    description_cat3 text,
    category_2_id integer REFERENCES category_2(id_c2) ON DELETE CASCADE
);




CREATE TABLE news (
    id_news serial PRIMARY KEY,
    data_create_n timestamp with time zone,
    authors_id integer,
    category_3_id integer REFERENCES category_3(id_c3),
    description_news text,
    main_photo_url_n text,
    other_photo_url_n text[],
    short_name_n text
);



CREATE TABLE news_tags (
    news_id integer ,
    tags_id integer 
);


CREATE TABLE session (
    id SERIAL PRIMARY KEY,
    key text,
    user_id integer REFERENCES user_blog(id_user),
    CONSTRAINT "IDENTITY(1,1)" CHECK (NULL::boolean)
);