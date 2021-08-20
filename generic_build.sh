#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

aws eks --region us-west-2 update-kubeconfig --name lower-eks

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/amd64/kubectl
sudo install kubectl /usr/local/bin

curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
sudo install skaffold /usr/local/bin/

# docker login -u travisjhoffman -p $GITHUB_TOKEN ghcr.io
export TARGET_SERVICE="${GITHUB_REPOSITORY/medshorts-llc\/}"

export SKAFFOLD_DEFAULT_REPO=ghcr.io
export SKAFFOLD_VERBOSITY=info
export SKAFFOLD_AUTO_DEPLOY=true
export SKAFFOLD_BUILD_CONCURRENCY=1
export SKAFFOLD_MUTE_LOGS=none
export SKAFFOLD_VERBOSITY=info
export SKAFFOLD_WAIT_FOR_DELETIONS=false
export SKAFFOLD_INTERACTIVE=false

cd $GITHUB_WORKSPACE/medigi-skaffold

branch_name=$(git rev-parse --abbrev-ref HEAD)
export SKAFFOLD_NAMESPACE=$(cat services/$TARGET_SERVICE/.deploy-targets.json | jq ".$branch_name[].K8S_NAMESPACE" -r)
export K8S_NAMESPACE=$SKAFFOLD_NAMESPACE

bash $SCRIPT_DIR/k8s-templates.sh
skaffold run --default-repo=ghcr.io --kube-context='arn:aws:eks:us-west-2:392331991905:cluster/lower-eks'
cd -
