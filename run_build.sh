#!/usr/bin/env bash

echo "Conjuring environment files for all matched deployment targets..."
python3 build-tools/gen_build_env.py $GITHUB_REF

$(aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 392331991905.dkr.ecr.us-west-2.amazonaws.com)

npm install -g tc-cli

for fname in **/.build.*.env; do
    if [ -f "$fname" ]; then
        set -a
        . $fname
        set +a

        if [ "$SHOULD_DEPLOY" = "YES" ]; then
            if [ "$TESTCRAFT" = "YES" ]; then
                python3 build-tools/gen_build_env.py $TEST_TARGET

                set -a
                . **/.build.$TEST_TARGET_ENV.env
                set +a

                echo Running build hook
                ./build/build.sh

                set -a
                . **/.build.$TEST_TARGET_ENV.env
                set +a

                echo "Deploying to test environment..."
                ./build/deploy.sh

                result=$(tc-cli run -u travis@medshorts.com -t DFA12339B3934E65A24BE08FDC67086E -p "Medshorts" -v "Base" -s "$TESTCRAFT_SUITE" -l "Chrome" -e "$TESTCRAFT_ENV" | grep "Test Result: Success")

                if [ -z "$result" ]; then
                    echo "Tests failed! Post-test deploy aborted."
                else
                    echo "Tests passed! Building..."
                    set -a
                    . $fname
                    set +a

                    echo Running build hook
                    ./build/build.sh

                    set -a
                    . $fname
                    set +a

                    echo "Deploying..."
                    ./build/deploy.sh
                fi
            else
                set -a
                . $fname
                set +a

                echo Running build hook
                ./build/build.sh

                set -a
                . $fname
                set +a

                ./build/deploy.sh
            fi
        fi
    fi

    SHOULD_DEPLOY="NO"
done
