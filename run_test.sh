#!/usr/bin/env bash

echo "SHOULD_TEST is $SHOULD_TEST"
if [ "$SHOULD_TEST" = "1" ]; then
    echo "RUNNING TEST"
    bash build/test.sh
fi
