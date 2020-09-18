INSERT INTO user_blog (name_user, last_name_user, login, password , avatar, data_create_u, admini, author)
VALUES ('Pasha','Dragon','pasha@test.com','3456ABCDefgh','https://nlotv.com/ru/news/view/6554-novye-kadry-iz-avatar-2-predstavili-druguyu-lokaciyu-pandory','2001-09-29 00:00:00',true,true);

INSERT INTO user_blog (name_user, last_name_user, login, password , avatar, data_create_u, admini, author)
VALUES ('Igor','Kram','kram777@test.com','3456ABCDesdfds','emodgi','2001-09-29 00:00:00',false,true);

INSERT INTO user_blog (name_user, last_name_user, login, password , avatar, data_create_u, admini, author)
VALUES ('Oleg','Ax','oleg@test.com','5678ABCDefgh','some avatar','2001-09-29 00:00:00',true,false);

INSERT INTO user_blog (name_user, last_name_user, login, password , avatar, data_create_u, admini, author)
VALUES ('Fedor','Nikolaev','nikolaevXXX@mailtest.com','4678dBCJefgh','non pictures','2001-09-29 00:00:00',false,false);





INSERT INTO category_1 (description_cat1) VALUES ('Политика');
INSERT INTO category_1 (description_cat1) VALUES ('Экономика');
INSERT INTO category_1 (description_cat1) VALUES ('Культура');






INSERT INTO comments (element_comment) VALUES((1,'дожились','2005-09-29 00:00:00',1,2)); 
INSERT INTO comments (element_comment) VALUES((2,'напрашивается анекдот','2011-09-19 00:00:00',1,3)); 
INSERT INTO comments (element_comment) VALUES((3,'так держать','2011-09-24 00:00:00',2,3)); 
INSERT INTO comments (element_comment) VALUES((4,'о боже мой','2002-04-21 00:00:00',2,4)); 


INSERT INTO drafts (elements_draft) VALUES((1,'some text draft for 1 news','2011-09-19 00:00:00',1,'main photo 1 news draft','{"draft 1 photo", "draft 2 photo"}','draft1'));
INSERT INTO drafts (elements_draft) VALUES((2,'some text draft for 2 news','2011-09-19 00:00:00',2,'main photo 2 news draft','{"draft 1 photo", "draft 2 photo"}','draft2'));
INSERT INTO drafts (elements_draft) VALUES((3,'some text draft for 3 news','2011-09-19 00:00:00',3,'main photo 3 news draft','{"draft 1 photo", "draft 2 photo"}','draft3'));


INSERT INTO tags (element_tags) VALUES((1,'Россия'));
INSERT INTO tags (element_tags) VALUES((2,'Франция'));
INSERT INTO tags (element_tags) VALUES((3,'Утрешние'));
INSERT INTO tags (element_tags) VALUES((4,'Звезды'));




