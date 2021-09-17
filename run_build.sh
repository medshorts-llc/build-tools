#!/usr/bin/env bash

echo "Conjuring environment files for all matched deployment targets..."
python3 build-tools/gen_build_env.py $GITHUB_REF

$(aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 392331991905.dkr.ecr.us-west-2.amazonaws.com)

npm install -g tc-cli

trigger_target=""
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

            if [ "$TESTCRAFT" = "YES" ]; then
                echo "Running TestCraft suite..."

                result=$(tc-cli run -u travis@medshorts.com -t DFA12339B3934E65A24BE08FDC67086E -p "Production" -v "Base" -s "$TESTCRAFT_SUITE" -l "Chrome 1920x1080" -e "$TESTCRAFT_ENV" | grep "Test Result: Success")

                if [ -z "$result" ]; then
                    echo "Tests failed! Post-test deploy aborted."
                else
                    echo "Tests passed! Post-test deploying to $TRIGGER_TARGET targets."
                    python3 build-tools/gen_build_env.py $TRIGGER_TARGET

                    set -a
                    . **/.build.$TRIGGER_TARGET_ENV.env
                    set +a

                    echo Running build hook
                    ./build/build.sh

                    set -a
                    . **/.build.$TRIGGER_TARGET_ENV.env
                    set +a

                    if [ "$SHOULD_DEPLOY" = "YES" ]; then
                        echo "Running deploy hook"
                        ./build/deploy.sh
                    fi
                fi
            fi
        fi
    fi

    SHOULD_DEPLOY="NO"
done
