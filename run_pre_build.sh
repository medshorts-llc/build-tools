#!/usr/bin/env bash

echo "Run pre_build hook..."

cd $CODEBUILD_SRC_DIR

$(aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com)

chmod +x ./build-tools/run_build.sh
chmod +x ./build-tools/run_test.sh
chmod +x ./build/build.sh
chmod +x ./build/deploy.sh
chmod +x ./build/pre_build.sh
bash build/pre_build.sh
