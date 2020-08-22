#! /bin/bash

#здесь я использую уже готовую сессию из базы данных для куки
#это сессия админа - если брать другую то соответственно доступа не будет

curl -b  'sId=DugnAy1p5WjuKr8btGLa0nIHjwtlcE3d' -d '{"id_category_2":8,"name_category_2":"Meditathion","category1":{"id_category_1":5,"name_category_1":"Health"}}'  -X POST http://localhost:3000/api/create/category2  -H «Content-Type:application/json»