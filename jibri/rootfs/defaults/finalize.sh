#!/bin/bash

AWS_ACCESS_KEY=
AWS_SECRET_KEY=
AWS_DEFAULT_REGION=eu-west-1
S3_BUCKET_NAME=jibri-video-dev

RECORDINGS_DIR=$1

echo $RECORDINGS_DIR
echo "Uploading to S3"

RECORDINGS=`ls $RECORDINGS_DIR/`
RECORDINGS=`basename $RECORDINGS`
FOLDER_NAME=$(echo $RECORDINGS | tr "_" "\n")

for name in $FOLDER_NAME
do
    FOLDER_NAME=$name
break
done

upload(){
    echo "Uploading..."
    aws configure set aws_access_key_id $AWS_ACCESS_KEY
    aws configure set aws_secret_access_key $AWS_SECRET_KEY
    aws configure set default.region $AWS_DEFAULT_REGION
    aws s3 sync $RECORDINGS_DIR s3://$S3_BUCKET_NAME/$FOLDER_NAME
}

upload