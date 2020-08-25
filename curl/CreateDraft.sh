#! /bin/bash


curl -b  'sId=aRv7bZEq0uhXROOQkra5p0n80YF2AtoC' -d '{"main_photo_url":"test 1 main photo url","news_id_draft":1,"id_draft":10,"other_photo_url":{"fromPGArray":["test 1 other photo","test 1 other photo2"]},"text_draft":"test 2 draft","short_name":"TestDragtForFirstNews","data_create_draft":"1970-01-01T00:00:00Z"}'  -X POST http://localhost:3000/api/create/draft  -H «Content-Type:application/json»



    # '{"id_draft":7,"text_draft":"Politic Every day News of Australia","data_create_draft":"2011-11-19 18:28:52.607875 UTC","news_id_draft":2,"main_photo_url":"mainUrlPhoto","other_photo_url":["photoUrl1","photoUrl2"],"short_name":"Morning Australia"}'
# {\"main_photo_url\":\"test 1 main photo url\",\"news_id_draft\":1,\"id_draft\":2,\"other_photo_url\":{\"fromPGArray\":[\"test 1 other photo\",\"test 1 other photo2\"]},\"text_draft\":\"test 2 draft\",\"short_name\":\"TestDragtForFirstNews\",\"data_create_draft\":\"1970-01-01T00:00:00Z\"}