#!/bin/bash

docker login -u moldy1984 -p Fr0glick!
rm docker-compose.override.yml
cp build/build.sh medshorts-app/