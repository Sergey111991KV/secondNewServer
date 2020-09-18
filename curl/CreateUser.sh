#! /bin/bash


curl -b  'sId=M3nH3RlHTR45bpwbRCal5q3xr7069kVT' -d '{"authAdmin":false,"lastName":"Jakovlev","dataCreate":"2001-09-28T20:00:00Z","authPassword":"3456ABCDesdfds","nameU":"Anton","authAuthor":true,"authLogin":"ramsdf777@test.com","id_user":2,"avatar":"emodgi"}'  -X POST http://localhost:3000/api/create/user  -H «Content-Type:application/json»