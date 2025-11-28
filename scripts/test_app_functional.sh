#!/usr/bin/env bash
set -euo pipefail
IP=$(kubectl get ingress quadara-backend-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Testing IP: $IP"
for p in auth device monitor; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "http://$IP/$p")
  echo "$p -> HTTP $code"
done
