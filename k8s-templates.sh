source ./tools/constants.sh

branch_name=$(git rev-parse --abbrev-ref HEAD)

if [ ! -d k8s ]; then
    mkdir k8s
fi

cp k8s-templates/* k8s/


for svc in "${SERVICE_NAMES[@]}"
do
    sed -e "s/{{ k8s_namespace }}/$K8S_NAMESPACE/g" k8s-templates/"$svc".yaml > k8s/"$svc".yaml
done

SED_AWS_SAK=$(printf '%s\n' "$AWS_SECRET_ACCESS_KEY" | sed -e 's/[\/&]/\\&/g')
sed -e "s/{{ k8s_namespace }}/$K8S_NAMESPACE/g" k8s-templates/skaffold-cicd.yaml > skaffold.yaml
sed -e "s/{{ target }}/$TARGET_SERVICE/g" k8s/skaffold-cicd.yaml > skaffold.yaml
sed -e "s/{{ k8s_namespace }}/$K8S_NAMESPACE/g" k8s-templates/ambassador-maps.yaml > k8s/ambassador-maps.yaml
sed -e "s/{{ mysql_password }}/overrideme/g" k8s-templates/configmaps.yaml > k8s/configmaps.yaml
sed -i -e "s/{{ k8s_namespace }}/$K8S_NAMESPACE/g" k8s/configmaps.yaml
sed -i -e "s/{{ DEV_AWS_ACCESS_KEY_ID }}/$AWS_ACCESS_KEY_ID/g" k8s/configmaps.yaml
sed -i -e "s/{{ DEV_AWS_SECRET_ACCESS_KEY }}/$SED_AWS_SAK/g" k8s/configmaps.yaml
