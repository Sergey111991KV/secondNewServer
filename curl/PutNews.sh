#! /bin/bash

#здесь я использую уже готовую сессию из базы данных для куки

curl -b  'sId=M3nH3RlHTR45bpwbRCal5q3xr7069kVT' -d '{"short_name_news":"TodayNews","tegs":{"fromPGArray":[{"id_teg":7,"name_teg":"Health"}]},"text_news":"News of Today","category":{"name_category_3":"Meditation in India","category2":{"id_category_2":8,"name_category_2":"Meditation","category1":{"name_category_1":"Health","id_category_1":4}},"id_category_3":12},"data_create_news":"2011-11-19T18:28:52.607875Z","other_photo_url_news":{"fromPGArray":["test 1 other photo","test 1 other photo2"]},"drafts":{"fromPGArray":[{"main_photo_url":"test 2 main photo url","news_id_draft":1,"id_draft":2,"other_photo_url":{"fromPGArray":["test 1 other photo","test 1 other photo2"]},"text_draft":"test 2 draft","short_name":"TestDragtForFirstNews","data_create_draft":"2011-11-19T18:28:52.607875Z"},{"main_photo_url":"test 2 main photo url","news_id_draft":1,"id_draft":3,"other_photo_url":{"fromPGArray":["test 1 other photo","test 1 other photo2"]},"text_draft":"test 3 draft","short_name":"TestDragtForFirstNews","data_create_draft":"2011-11-19T18:28:52.607875Z"}]},"authors":{"id_author":1,"user":{"authAdmin":true,"lastName":"Abramov","dataCreate":"2011-11-19T18:28:52.607875Z","authPassword":"qwerty","nameU":"Daniel","authAuthor":true,"authLogin":"daniel11","id_user":2,"avatar":"avatarDaniel"},"description":"TestAutor1"},"main_photo_url_news":"url main Photo","id_news":1,"comments":{"fromPGArray":[{"users_id_comments":1,"news_id_comments":1,"id_comments":6,"data_create_comments":"2011-11-19T18:28:52.607875Z","text_comments":"test comment4"}]}}'  -X PUT http://localhost:3000/api/put/news  -H «Content-Type:application/json»