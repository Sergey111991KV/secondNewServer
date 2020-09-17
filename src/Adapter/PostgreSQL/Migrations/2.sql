-- INSERT INTO user_blog (name_user, last_name_user, login, password , avatar, data_create_u, admini, author)
-- VALUES ('Pasha','Dragon','pasha@test.com','3456ABCDefgh','https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory','2001-09-29 00:00:00',true,true);

-- INSERT INTO user_blog (name_user, last_name_user, login, password , avatar, data_create_u, admini, author)
-- VALUES ('Igor','Kram','kram777@test.com','3456ABCDesdfds','emodgi','2001-09-29 00:00:00',false,true);

-- INSERT INTO user_blog (name_user, last_name_user, login, password , avatar, data_create_u, admini, author)
-- VALUES ('Oleg','Ax','oleg@test.com','5678ABCDefgh','some avatar','2001-09-29 00:00:00',true,false);

-- INSERT INTO user_blog (name_user, last_name_user, login, password , avatar, data_create_u, admini, author)
-- VALUES ('Fedor','Nikolaev','nikolaevXXX@mailtest.com','4678dBCJefgh','non pictures','2001-09-29 00:00:00',false,false);



-- INSERT INTO session (key, user_id) values ('M3nH3RlHTR45bpwbRCal5q3xr7069kVT',1);



-- INSERT INTO author (description_author, id_user_a) VALUES ('Советский шпион',1);

-- INSERT INTO author (description_author, id_user_a) VALUES ('Европейский маргинал',2);


-- INSERT INTO category_1 (description_cat1) VALUES ('Политика');
-- INSERT INTO category_1 (description_cat1) VALUES ('Экономика');
-- INSERT INTO category_1 (description_cat1) VALUES ('Культура');

-- INSERT INTO category_2 (description_cat2, category_1_id) VALUES ('Внутренняя',1);
-- INSERT INTO category_2 (description_cat2, category_1_id) VALUES ('Внешняя',1);
-- INSERT INTO category_2 (description_cat2, category_1_id) VALUES ('Макро',2);
-- INSERT INTO category_2 (description_cat2, category_1_id) VALUES ('Микро',2);
-- INSERT INTO category_2 (description_cat2, category_1_id) VALUES ('Развитие',3);
-- INSERT INTO category_2 (description_cat2, category_1_id) VALUES ('Сохранение',3);


-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Правительственные действия',1);
-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Принимаемые законы',1);
-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Европа',2);
-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Америка',2);
-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Автомобильные льготы на покупку',3);
-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Действия центробанка',3);
-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Цена на сезонные овощи',4);
-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Туристические путевки',4);
-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Мероприятия',5);
-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Финансирование культурных объектов',5);
-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Реставрации',6);
-- INSERT INTO category_3 (description_cat3, category_2_id) VALUES ('Меценатство',6);



-- INSERT INTO comments (element_comment) VALUES((1,'дожились','2005-09-29 00:00:00',1,2)); 
-- INSERT INTO comments (element_comment) VALUES((2,'напрашивается анекдот','2011-09-19 00:00:00',1,3)); 
-- INSERT INTO comments (element_comment) VALUES((3,'так держать','2011-09-24 00:00:00',2,3)); 
-- INSERT INTO comments (element_comment) VALUES((4,'о боже мой','2002-04-21 00:00:00',2,4)); 


-- INSERT INTO drafts (elements_draft) VALUES((1,'some text draft for 1 news','2011-09-19 00:00:00',1,'main photo 1 news draft','{"draft 1 photo", "draft 2 photo"}','draft1'));
-- INSERT INTO drafts (elements_draft) VALUES((2,'some text draft for 2 news','2011-09-19 00:00:00',2,'main photo 2 news draft','{"draft 1 photo", "draft 2 photo"}','draft2'));
-- INSERT INTO drafts (elements_draft) VALUES((3,'some text draft for 3 news','2011-09-19 00:00:00',3,'main photo 3 news draft','{"draft 1 photo", "draft 2 photo"}','draft3'));


-- INSERT INTO tags (element_tags) VALUES((1,'Россия'));
-- INSERT INTO tags (element_tags) VALUES((2,'Франция'));
-- INSERT INTO tags (element_tags) VALUES((3,'Утрешние'));
-- INSERT INTO tags (element_tags) VALUES((4,'Звезды'));




-- INSERT INTO news VALUES (0,'2011-08-01 00:00:00',1,1,'some description for 1 news','main photo 1 news ','{" 1 photo", " 2 photo"}','news 1');
-- INSERT INTO news VALUES (0,'2011-09-19 00:00:00',1,2,'some description for 2 news','main photo 2 news ','{" 1 photo", " 2 photo"}','news 2');
-- INSERT INTO news VALUES (0,'2012-01-10 00:00:00',1,3,'some description for 3 news','main photo 3 news ','{" 1 photo", " 2 photo"}','news 3');
-- INSERT INTO news VALUES (0,'2013-09-11 00:00:00',1,5,'some description for 4 news','main photo 4 news ','{" 1 photo", " 2 photo"}','news 4');
-- INSERT INTO news VALUES (0,'2014-04-19 00:00:00',2,5,'some description for 5 news','main photo 5 news ','{" 1 photo", " 2 photo"}','news 5');
-- INSERT INTO news VALUES (0,'2014-05-22 00:00:00',2,7,'some description for 6 news','main photo 6 news ','{" 1 photo", " 2 photo"}','news 6');
-- INSERT INTO news VALUES (0,'2020-03-18 00:00:00',2,8,'some description for 7 news','main photo 7 news ','{" 1 photo", " 2 photo"}','news 7');
-- INSERT INTO news VALUES (0,'2001-04-09 00:00:00',2,5,'some description for 8 news','main photo 8 news ','{" 1 photo", " 2 photo"}','news 8');