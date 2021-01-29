#!/bin/bash
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
AWS_DEFAULT_REGION=eu-west-1

# Should be replaced by env var
S3_BUCKET_NAME=jibri-video-dev

# /config/recordings/<jibri-generated-dirname>
RECORDINGS_DIR=$1

# extract <jibri-generated-dirname> and use for S3 key (dir)
RECORDING_KEY=$(echo "$RECORDINGS_DIR" | sed 's|.*/||')

echo "[FINALIZE]: WILL MOVE FILES FROM ${RECORDINGS_DIR} TO s3://${S3_BUCKET_NAME}/${RECORDING_KEY}"

upload(){
    echo "Uploading..."
    aws configure set aws_access_key_id $AWS_ACCESS_KEY
    aws configure set aws_secret_access_key $AWS_SECRET_KEY
    aws configure set default.region $AWS_DEFAULT_REGION
    aws s3 mv $RECORDINGS_DIR s3://$S3_BUCKET_NAME/$RECORDING_KEY --recursive
}

upload