#!/usr/bin/env bash

aws s3 cp medshorts-app/dist/medshorts-app/ s3://$S3_ORIGIN/ --recursive
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"
