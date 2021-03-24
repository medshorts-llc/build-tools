#!/usr/bin/env bash

function cache_node_modules {
    cd medshorts-app
    tar -c node_modules > node_modules.tar
    gzip node_modules.tar
    aws s3 cp node_modules.tar.gz s3://$S3_ORIGIN/node_modules.tar.gz
    cd ..
}

function fetch_cached_node_modules {
    cd medshorts-app
    aws s3 cp s3://$S3_ORIGIN/node_modules.tar.gz node_modules.tar.gz
    tar -xzf node_modules.tar.gz
    rm node_modules.tar.gz
    cd ..
}

function build_frontend {
    rm docker-compose.override.yml
    docker-compose run -e ANGULAR_CONFIG=$ANGULAR_CONFIG frontend-build bash /app/tools/build.sh
}

fetch_cached_node_modules
build_frontend
cache_node_modules
