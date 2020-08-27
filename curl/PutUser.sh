#! /bin/bash

#здесь я использую уже готовую сессию из базы данных для куки

curl -b  'sId=DugnAy1p5WjuKr8btGLa0nIHjwtlcE3d' -d '{authAdmin":true,"lastName":"Abramov","dataCreate":"2011-11-19T18:28:52.607875Z","authPassword":"qwerty","nameU":"Daniel","authAuthor":true,"authLogin":"daniel11","id_user":33,"avatar":"avatarDaniel"}'  -X put http://localhost:3000/api/put/user  -H «Content-Type:application/json»