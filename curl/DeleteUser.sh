#! /bin/bash

#здесь я использую уже готовую сессию из базы данных для куки

curl -b  'sId=DugnAy1p5WjuKr8btGLa0nIHjwtlcE3d' -X DELETE http://localhost:3000/api/delete/comment/4