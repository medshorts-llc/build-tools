#!/usr/bin/env bash

# $(aws ecr get-login-password --no-include-email --region $AWS_DEFAULT_REGION)
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/amd64/kubectl
chmod +x ./kubectl

touch api/.local.env
