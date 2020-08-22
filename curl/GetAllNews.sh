#! /bin/bash

#получить все новости - здесь не нужны куки

curl -b  'sId=' -X GET http://localhost:3000/api/getAll/news