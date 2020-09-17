#! /bin/bash


curl -b  'sId=M3nH3RlHTR45bpwbRCal5q3xr7069kVT' -d '{"users_id_comments":1,"news_id_comments":1,"id_comments":6,"data_create_comments":"2011-11-19T18:28:52.607875Z","text_comments":"test comment4"}'  -X POST http://localhost:3000/api/create/comment  -H «Content-Type:application/json»


