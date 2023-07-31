#!/bin/bash

# Variables
# S3_BUCKET="vprofile-prod"
# ARTIFACT_PATH="target/vprofile-${version}.war"
# WEBAPPS_DIR="/var/lib/tomcat9/webapps"

# # Copy artifact from S3 bucket to webapps directory
# LATEST_OBJECT=$(aws s3api list-objects --bucket $S3_BUCKET --query 'Contents[].{Key: Key, LastModified: LastModified}' --output json | jq -r '.[] | "\(.LastModified)\t\(.Key)"' | sort -r | head -1 | cut -f2)
# aws s3 cp s3://$S3_BUCKET/$LATEST_OBJECT $WEBAPPS_DIR
# mv *.war vprofile-app.war

# echo "Artifact copied succesfully"

aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 851481789693.dkr.ecr.ap-south-1.amazonaws.com
docker pull 851481789693.dkr.ecr.ap-south-1.amazonaws.com/vprofile-qa:vprofileapp-%version%