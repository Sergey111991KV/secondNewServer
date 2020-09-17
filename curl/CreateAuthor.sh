#! /bin/bash


curl -b  'sId=M3nH3RlHTR45bpwbRCal5q3xr7069kVT' -d '{"id_author":0,"user":{"authAdmin":true,"lastName":"Abramov","dataCreate":"2011-11-19T18:28:52.607875Z","authPassword":"qwerty","nameU":"Daniel","authAuthor":true,"authLogin":"daniel11","id_user":2,"avatar":"avatarDaniel"},"description":"TestAutor1"}'  -X POST http://localhost:3000/api/create/author  -H «Content-Type:application/json»


