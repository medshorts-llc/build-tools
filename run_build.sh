#!/usr/bin/env bash

echo "Conjuring environment files for all matched deployment targets..."
python build/gen_build_env.py $CODEBUILD_WEBHOOK_HEAD_REF

for fname in **/.build.*.env; do
    if [ -f "$fname" ]; then
        set -a
        . $fname
        set +a

        echo Running build hook
        ./build/build.sh

        cd $CODEBUILD_SRC_DIR

        set -a
        . $fname
        set +a

        if [ "$SHOULD_DEPLOY" = "YES" ]; then
            echo "Running deploy hook"
            ./build/deploy.sh
        fi
    fi
    SHOULD_DEPLOY="NO"
    cd $CODEBUILD_SRC_DIR
done
