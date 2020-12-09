#!/usr/bin/env bash

echo "Run pre_build hook..."

cd $CODEBUILD_SRC_DIR

chmod +x ./build-tools/run_pre_build.sh
chmod +x ./build-tools/run_build.sh
chmod +x ./build-tools/run_test.sh
chmod +x ./build/build.sh
chmod +x ./build/deploy.sh

bash build/pre_build.sh
