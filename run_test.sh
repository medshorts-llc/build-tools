#!/usr/bin/env bash

if [ "$SHOULD_TEST" = "1" ]; then
    echo "RUNNING TEST"
    bash build/test.sh
fi
