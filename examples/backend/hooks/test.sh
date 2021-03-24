#!/usr/bin/env bash

echo "Starting test container..."
docker-compose run --no-deps -w /app app bash -c "pip install -r requirements-docker.txt && python -m pytest tests"
