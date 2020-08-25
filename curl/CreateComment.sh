#! /bin/bash


curl -b  'sId=aRv7bZEq0uhXROOQkra5p0n80YF2AtoC' -d '{"users_id_comments":1,"news_id_comments":1,"id_comments":5,"data_create_comments":"2011-11-19T18:28:52.607875Z","text_comments":"test comment4"}'  -X POST http://localhost:3000/api/create/comment  -H «Content-Type:application/json»


