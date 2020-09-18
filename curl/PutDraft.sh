#! /bin/bash

#здесь я использую уже готовую сессию из базы данных для куки

curl -b  'sId=M3nH3RlHTR45bpwbRCal5q3xr7069kVT' -d '{"main_photo_url":"test 1 main photo url","news_id_draft":1,"id_draft":3,"other_photo_url":{"fromPGArray":["test 111 other photo","test 111 other photo2"]},"text_draft":"test 2222 draft","short_name":"TestDragtForFirstNews","data_create_draft":"1970-01-01T00:00:00Z"}'  -X PUT http://localhost:3000/api/put/draft  -H «Content-Type:application/json»