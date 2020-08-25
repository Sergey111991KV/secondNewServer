#! /bin/bash

#здесь я использую уже готовую сессию из базы данных для куки

curl -b  'sId=DugnAy1p5WjuKr8btGLa0nIHjwtlcE3d' -d '{"id_category_2" : 7, "name_category_2" : "MinskNews" , "category1" : {"id_category_1" : 3 , "name_category_1" = "Politics"}}'  -X PUT http://localhost:3000/api/put/category2  -H «Content-Type:application/json»