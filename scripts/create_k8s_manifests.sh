#!/usr/bin/env bash
set -euo pipefail
set -a; source env/.env.generated; set +a
ACR_LOGIN_SERVER=$(az acr show -n "$ACR_NAME" --query loginServer -o tsv)
sed -i "s#__ACR__#${ACR_LOGIN_SERVER}#g" k8s/backend/deployments.yaml
echo "Updated manifests with ACR: $ACR_LOGIN_SERVER"
