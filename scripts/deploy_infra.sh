#!/usr/bin/env bash
set -euo pipefail
set -a; source env/.env.generated; set +a
pushd terraform >/dev/null
terraform init -upgrade
terraform apply -auto-approve -var "db_admin_password=${DB_ADMIN_PASSWORD}"
popd >/dev/null
terraform -chdir=terraform output
