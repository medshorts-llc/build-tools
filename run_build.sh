#!/usr/bin/env bash

echo "Conjuring environment files for all matched deployment targets..."
python3 build-tools/gen_build_env.py $GITHUB_REF

$(aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 392331991905.dkr.ecr.us-west-2.amazonaws.com)

. api/.test.env
# ./build/test.sh || exit 1

for fname in **/.build.*.env; do
    if [ -f "$fname" ]; then

        set -a
        . $fname
        set +a

        echo Running build hook
        ./build/build.sh

        set -a
        . $fname
        set +a

        if [ "$SHOULD_DEPLOY" = "YES" ]; then
            echo "Running deploy hook"
            ./build/deploy.sh
        fi
    fi
    SHOULD_DEPLOY="NO"
done
