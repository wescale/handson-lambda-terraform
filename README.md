# Launch

## Create connect file

Create a file in the root directory of this project.

Name this file "script-connect-aws.sh", it'll be ignored by git. (cf .gitignore)

```bash
#!/usr/bin/env bash
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_STS AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SECURITY_TOKEN AWS_SESSION_TOKEN
export USERNAME=***
export AWS_DEFAULT_REGION=eu-west-1
export AWS_ACCESS_KEY_ID=***
export AWS_SECRET_ACCESS_KEY=***
export ROLE_NAME=handson-serverless-role-name
export ACCOUNT_ARN=arn:aws:iam::***
export MFA_CODE=$1
AWS_STS=($(aws sts assume-role --role-arn $ACCOUNT_ARN:role/$ROLE_NAME --serial-number $ACCOUNT_ARN:mfa/$USERNAME --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken,Credentials.Expiration]' --output text --token-code $MFA_CODE --role-session-name $ROLE_NAME))
export AWS_ACCESS_KEY_ID=${AWS_STS[0]}
export AWS_SECRET_ACCESS_KEY=${AWS_STS[1]}
export AWS_SECURITY_TOKEN=${AWS_STS[2]}
export AWS_SESSION_TOKEN=${AWS_STS[2]}
```

You have to change: 
- export USERNAME with your AWS login
- export AWS_ACCESS_KEY_ID with your AWS access key
- export AWS_SECRET_ACCESS_KEY with your AWS secret access key
- export ACCOUNT_ARN=arn:aws:iam::*** : replace *** by your AWS account id

## Get your credential

```bash
source ./script-connect-aws.sh LASTMFACODE
```

## Create infrastructure

### The first time you use it localy, please follow this step:
```bash
python ci-cd/init.py
```

### Launch script

```bash
python ci-cd/start.py
```

## Delete infrastructure

```bash
python ci-cd/stop.py
```
