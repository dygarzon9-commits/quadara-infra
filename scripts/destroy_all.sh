#!/usr/bin/env bash
set -euo pipefail
if [ -f env/.env.generated ]; then
  set -a; source env/.env.generated; set +a
else
  RESOURCE_GROUP="ParentalControl-RG"
fi
echo "Deleting resource group: $RESOURCE_GROUP"
az group delete --name "$RESOURCE_GROUP" --yes --no-wait || true
for rg in $(az group list --query "[?starts_with(name,'MC_')].name" -o tsv); do
  az group delete --name "$rg" --yes --no-wait || true
done
for kv in $(az keyvault list-deleted -o tsv --query [].name 2>/dev/null); do
  az keyvault purge --name "$kv" || true
done
echo "Requested deletions."
