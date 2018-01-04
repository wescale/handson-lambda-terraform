#!/bin/bash

url=https://7kxst4lxv6.execute-api.eu-west-1.amazonaws.com/dev

curl -X GET $url/demo/users
curl -X POST -d '{ "firstname":"sebastien", "lastname":"lavayssiere" }' $url/demo/users
curl -X GET $url/demo/users/a5fbd7dd-dda2-4beb-9a0d-5985972ac2d7
curl -X DELETE $url/demo/users/a5fbd7dd-dda2-4beb-9a0d-5985972ac2d7

curl -X PATCH -d '{ "firstname":"seb", "lastname":"lav" }' $url/demo/users/a5240c83-ea4b-4f3d-9d28-ee6531bf07bf

