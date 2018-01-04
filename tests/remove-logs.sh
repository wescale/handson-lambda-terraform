#!/bin/bash

aws logs delete-log-group --log-group-name /aws/lambda/demo_users_get_function
aws logs delete-log-group --log-group-name /aws/lambda/demo_users_post_function
aws logs delete-log-group --log-group-name /aws/lambda/demo_users_userid_delete_function
aws logs delete-log-group --log-group-name /aws/lambda/demo_users_userid_get_function
aws logs delete-log-group --log-group-name /aws/lambda/demo_users_userid_patch_function
