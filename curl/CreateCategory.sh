#! /bin/bash

#здесь я использую уже готовую сессию из базы данных для куки
#это сессия админа - если брать другую то соответственно доступа не будет

curl -b  'sId=M3nH3RlHTR45bpwbRCal5q3xr7069kVT' -d '{"id_category_2":8,"name_category_2":"Meditathion","category1":{"id_category_1":1,"name_category_1":"_"}}'  -X POST http://localhost:3000/api/create/category2  -H «Content-Type:application/json»