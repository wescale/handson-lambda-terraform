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

if [ "$project" == "users" ]; then
  aws lambda update-function-code --function-name demo_users_get_function           --s3-bucket demo-handson-serverless-package --s3-key $project/$project-lambda-$version.zip --publish
  aws lambda update-function-code --function-name demo_users_post_function          --s3-bucket demo-handson-serverless-package --s3-key $project/$project-lambda-$version.zip --publish
  aws lambda update-function-code --function-name demo_users_delete_function        --s3-bucket demo-handson-serverless-package --s3-key $project/$project-lambda-$version.zip --publish
  aws lambda update-function-code --function-name demo_users_userid_delete_function --s3-bucket demo-handson-serverless-package --s3-key $project/$project-lambda-$version.zip --publish
  aws lambda update-function-code --function-name demo_users_userid_get_function    --s3-bucket demo-handson-serverless-package --s3-key $project/$project-lambda-$version.zip --publish
  aws lambda update-function-code --function-name demo_users_userid_patch_function  --s3-bucket demo-handson-serverless-package --s3-key $project/$project-lambda-$version.zip --publish
fi
