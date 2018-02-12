#!/bin/bash

env=dev
project=users
version=beta

cd ../$project

echo $PWD

pip install -r requirements.txt

zip -q -r $project-lambda-$version.zip *
zip -q -d $project-lambda-$version.zip setup.cfg .gitignore

aws s3 cp ./$project-lambda-$version.zip s3://demo-handson-serverless-package/$project/$project-lambda-$version.zip

rm $project-lambda-$version.zip
