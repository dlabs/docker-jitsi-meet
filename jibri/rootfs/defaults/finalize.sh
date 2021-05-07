#!/bin/bash

AWS_ACCESS_KEY=
AWS_SECRET_KEY=
AWS_DEFAULT_REGION=eu-west-1
S3_BUCKET_NAME=jibri-video-dev

# /config/recordings/<jibri-generated-dirname>
RECORDINGS_DIR=$1
echo "[FINALIZE]: RECORDING DIR IS ${RECORDINGS_DIR}"

# extract <jibri-generated-dirname>
RECORDING_KEY=$(echo "$RECORDINGS_DIR" | sed 's|.*/||')
echo "[FINALIZE]: RECORDING KEY IS ${RECORDING_KEY}"

# the generic name of the video filename
S3_VIDEO_FILENAME="recording.mp4"

# extract conversation-id from jibri-generated filename 
FILE=$(find "$RECORDINGS_DIR" -type f -name "*.mp4")
FILENAME=$(echo "$FILE" | sed 's|.*/||')
arrIN=(${FILE//_/ })
CONVERSATION_ID=$(echo "${arrIN[0]}" | sed 's|.*/||')

echo "[FINALIZE]: CONVERSATION ID IS ${CONVERSATION_ID}"
echo "[FINALIZE]: RENAMING ${FILE} TO ${RECORDINGS_DIR}/${S3_VIDEO_FILENAME}"

# rename local file
mv $FILE "${RECORDINGS_DIR}/${S3_VIDEO_FILENAME}"
echo "[FINALIZE]: MOVING FILES FROM ${RECORDINGS_DIR} TO s3://${S3_BUCKET_NAME}/${CONVERSATION_ID}"

upload(){
    echo "[FINALIZE]: UPLOADING TO S3..."
    aws configure set aws_access_key_id $AWS_ACCESS_KEY
    aws configure set aws_secret_access_key $AWS_SECRET_KEY
    aws configure set default.region $AWS_DEFAULT_REGION
    aws s3 mv $RECORDINGS_DIR s3://$S3_BUCKET_NAME/$CONVERSATION_ID --recursive
}

upload