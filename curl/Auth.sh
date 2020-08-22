#! /bin/bash

# авторизация пользователя

curl -X GET http://localhost:3000/api/auth/5678ABCDefgh/oleg@test.com

# авторизация автора 

# curl -X GET http://localhost:3000/api/auth/1234ABCDefgh/victor@test.com

# # авторизация администратора

# curl -X GET http://localhost:3000/api/auth/5678ABCDefgh/oleg@test.com