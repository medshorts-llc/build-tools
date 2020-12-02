#!/usr/bin/env bash

if [ "$SHOULD_TEST" = "1" ]; then
    bash build/test.sh
fi

