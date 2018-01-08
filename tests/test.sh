#!/bin/bash

cd ../iac/layer-users
url=$(terraform output env_url)

curl -X GET $url/demo/users
curl -X POST -d '{ "firstname":"sebastien", "lastname":"lavayssiere" }' $url/demo/users | jq .

id_user=9b302ed0-a20f-4237-bf8a-6f0818674e64

curl -X GET $url/demo/users/$id_user
curl -X PATCH -d '{ "firstname":"seb", "lastname":"lav" }' $url/demo/users/$id_user
curl -X DELETE $url/demo/users/$id_user


