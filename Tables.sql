

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
	
	

CREATE TABLE author (
    id_author integer PRIMARY KEY,
    description_author text,
    id_user integer REFERENCES user_blog(id_user)
);


CREATE UNIQUE INDEX author_pkey ON author(id_author int4_ops);

CREATE TABLE category_1 (
    id_c1 integer DEFAULT nextval('category_1_id_seq'::regclass) PRIMARY KEY,
    description_cat1 text
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX category_1_pkey ON category_1(id_c1 int4_ops);

CREATE TABLE category_2 (
    id_c2 integer DEFAULT nextval('category_2_id_seq'::regclass) PRIMARY KEY,
    description_cat2 text,
    category_1_id integer REFERENCES category_1(id_c1) ON DELETE CASCADE
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX category_2_pkey ON category_2(id_c2 int4_ops);

CREATE TABLE category_3 (
    id_c3 integer DEFAULT nextval('category_3_id_seq'::regclass) PRIMARY KEY,
    description_cat3 text,
    category_2_id integer REFERENCES category_2(id_c2) ON DELETE CASCADE
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX category_3_pkey ON category_3(id_c3 int4_ops);


CREATE TABLE comments (
    element_comment comment_type PRIMARY KEY
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX comments_pkey ON comments(element_comment record_ops);


CREATE TABLE drafts (
    elements_draft drafts_type PRIMARY KEY
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX drafts_pkey ON drafts(elements_draft record_ops);


CREATE TABLE news (
    id_news integer PRIMARY KEY,
    data_create_n timestamp with time zone,
    authors_id integer,
    category_3_id integer REFERENCES category_3(id_c3),
    description_news text,
    main_photo_url_n text,
    other_photo_url_n text[],
    short_name_n text
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX news_pkey ON news(id_news int4_ops);


CREATE TABLE news_tags (
    news_id integer,
    tags_id integer
);

CREATE TABLE session (
    id SERIAL PRIMARY KEY,
    key text,
    user_id integer REFERENCES user_blog(id_user),
    CONSTRAINT "IDENTITY(1,1)" CHECK (NULL::boolean)
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX session_pkey ON session(id int4_ops);


CREATE TABLE schema_migrations (
    filename character varying(512) NOT NULL,
    checksum character varying(32) NOT NULL,
    executed_at timestamp without time zone NOT NULL DEFAULT now()
);

CREATE TABLE tags (
    element_tags teg_type PRIMARY KEY
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX tags_pkey ON tags(element_tags record_ops);


CREATE TABLE tagsss (
    element_tagsss text[]
);

CREATE TABLE user_blog (
    id_user integer DEFAULT nextval('user_id_seq'::regclass) PRIMARY KEY,
    name_user text,
    last_name_user text,
    login text,
    password text,
    avatar text,
    data_create_u timestamp with time zone,
    admini boolean,
    author boolean
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX user_pkey ON user_blog(id_user int4_ops);
