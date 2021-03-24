echo "Pushing the Docker image..."

docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME:$WHITELABEL_TAG
aws eks --region us-west-2 update-kubeconfig --name $CLUSTER_NAME
./kubectl set image deployment/$K8S_NAME $K8S_NAME=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME:$WHITELABEL_TAG
./kubectl rollout restart deployment/$K8S_NAME

