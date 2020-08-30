#! /bin/bash

#здесь я использую уже готовую сессию из базы данных для куки

curl -b  'sId=M3nH3RlHTR45bpwbRCal5q3xr7069kVT' -d '{"authAdmin":true,"lastName":"Abramojjv","dataCreate":"2011-11-19T18:28:52.607875Z","authPassword":"qwerty","nameU":"Daniel","authAuthor":true,"authLogin":"daniel1kk1","id_user":33,"avatar":"avatarDaniel"}'  -X PUT http://localhost:3000/api/put/user  -H «Content-Type:application/json»