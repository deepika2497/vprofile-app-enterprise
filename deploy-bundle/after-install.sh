#!/bin/bash

# Variables
S3_BUCKET="vprofileqa"
ARTIFACT_PREFIX="vprofile-"
WEBAPPS_DIR="/var/lib/tomcat9/webapps/"

# Get the latest version from S3 bucket
LATEST_VERSION=$(aws s3 ls "s3://$S3_BUCKET/" --recursive | grep "$ARTIFACT_PREFIX" | awk '{print $NF}' | sort -V | tail -n 1)

if [ -n "$LATEST_VERSION" ]; then
    ARTIFACT_PATH="s3://$S3_BUCKET/$LATEST_VERSION"

    # Copy artifact from S3 bucket to webapps directory
    echo "Copying artifact from S3 bucket to webapps directory..."
    aws s3 cp "$ARTIFACT_PATH" "$WEBAPPS_DIR/$(basename $LATEST_VERSION)"

    echo "Artifact copied successfully."
else
    echo "No artifact found in the S3 bucket."
fi

