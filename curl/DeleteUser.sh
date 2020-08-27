#! /bin/bash

#здесь я использую уже готовую сессию из базы данных для куки

curl -b  'sId=M3nH3RlHTR45bpwbRCal5q3xr7069kVT' -X DELETE http://localhost:3000/api/delete/user/8