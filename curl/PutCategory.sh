#! /bin/bash

#здесь я использую уже готовую сессию из базы данных для куки

curl -b  'sId=M3nH3RlHTR45bpwbRCal5q3xr7069kVT' -d '{"id_category_2":3,"name_category_2":"MinskNews","category1":{"id_category_1":3,"name_category_1":"Politics"}}'  -X PUT http://localhost:3000/api/put/category2  -H «Content-Type:application/json»