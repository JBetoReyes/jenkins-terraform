#!/bin/bash
timestamp=$(date +%Y%m%d%H%M%S)  
LC_CTYPE=C HASH=$(echo $timestamp)

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
REPOSITORY_NAME="jenkins-master"
REGION="us-west-1"
FOLDER_NAME="../jenkins-master/"
IMG_TAG=$HASH
LATEST_TAG=latest

# Docker Login | ECR Login
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Build image
REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME
docker build -t $REPOSITORY_URI:$LATEST_TAG $FOLDER_NAME

# Tag image
docker tag $REPOSITORY_URI:$LATEST_TAG $REPOSITORY_URI:$IMG_TAG

# Push image
docker push $REPOSITORY_URI:$LATEST_TAG
docker push $REPOSITORY_URI:$IMG_TAG