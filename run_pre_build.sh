#!/usr/bin/env bash

echo "Run pre_build hook..."
cd $CODEBUILD_SRC_DIR
bash build/pre_build.sh
