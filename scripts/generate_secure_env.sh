#!/usr/bin/env bash
set -euo pipefail
mkdir -p env
JWT=$(python - <<'PY'
import os, base64
print(base64.urlsafe_b64encode(os.urandom(32)).decode())
PY
)
: "${RESOURCE_GROUP:=ParentalControl-RG}"
: "${AKS_NAME:=parental-control-aks}"
: "${ACR_NAME:=quadaraacr}"
: "${STORAGE_ACCOUNT:=quadarawebstorage}"
: "${DB_ADMIN_USER:=pgadmin}"
: "${DB_ADMIN_PASSWORD:=Quadara!$(date +%s | cut -c-6)X}"

cat > env/.env.generated <<EOF
DB_ADMIN_USER=${DB_ADMIN_USER}
DB_ADMIN_PASSWORD=${DB_ADMIN_PASSWORD}
ACR_NAME=${ACR_NAME}
AKS_NAME=${AKS_NAME}
RESOURCE_GROUP=${RESOURCE_GROUP}
STORAGE_ACCOUNT=${STORAGE_ACCOUNT}
JWT_SECRET=${JWT}
EOF
echo "Generated env/.env.generated"
