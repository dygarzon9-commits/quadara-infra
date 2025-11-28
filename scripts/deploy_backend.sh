#!/usr/bin/env bash
set -euo pipefail

echo "=== Quadara Backend Deployment ==="

# -------------------------------------------------------------------
# 1. Cargar variables desde env/.env.generated
# -------------------------------------------------------------------
if [[ ! -f env/.env.generated ]]; then
  echo "❌ ERROR: No existe env/.env.generated"
  exit 1
fi

set -a
source env/.env.generated
set +a

echo "Variables cargadas:"
echo "  RESOURCE_GROUP=$RESOURCE_GROUP"
echo "  AKS_NAME=$AKS_NAME"
echo "  ACR_NAME=$ACR_NAME"

# -------------------------------------------------------------------
# 2. Verificar que ACR existe
# -------------------------------------------------------------------
echo "Validando existencia de ACR..."
if ! az acr show -n "$ACR_NAME" -g "$RESOURCE_GROUP" >/dev/null 2>&1; then
  echo "❌ ERROR: El ACR '$ACR_NAME' no existe en RG '$RESOURCE_GROUP'"
  exit 1
fi
echo "ACR encontrado ✓"

ACR_LOGIN_SERVER=$(az acr show -n "$ACR_NAME" --query loginServer -o tsv)

# -------------------------------------------------------------------
# 3. Asignar permisos AKS → ACR (evita ImagePullBackOff)
# -------------------------------------------------------------------
echo "Asegurando permiso AKS ↔ ACR..."
az aks update \
  -g "$RESOURCE_GROUP" \
  -n "$AKS_NAME" \
  --attach-acr "$ACR_NAME" >/dev/null
echo "Permisos OK ✓"

# -------------------------------------------------------------------
# 4. Obtener credenciales del cluster
# -------------------------------------------------------------------
echo "Obteniendo credenciales Kubectl..."
az aks get-credentials -g "$RESOURCE_GROUP" -n "$AKS_NAME" --overwrite-existing >/dev/null
echo "Credenciales cargadas ✓"

# -------------------------------------------------------------------
# 5. Construcción de imágenes en ACR
# -------------------------------------------------------------------
echo "Construyendo imágenes ACR..."
for svc in auth-service device-management-service monitoring-service; do
  echo "⏳ Build -> $svc"
  az acr build -r "$ACR_NAME" -t "$svc:latest" "backend/$svc"
  echo "  ✓ $svc construido"
done

# -------------------------------------------------------------------
# 6. Aplicar manifests K8s
# -------------------------------------------------------------------
echo "Actualizando deployments…"
TMPDIR=$(mktemp -d)
sed "s#__ACR__#${ACR_LOGIN_SERVER}#g" k8s/backend/deployments.yaml > "$TMPDIR/deployments.yaml"

kubectl apply -f "$TMPDIR/deployments.yaml"
kubectl apply -f k8s/backend/ingress.yaml
echo "Manifiestos aplicados ✓"

# -------------------------------------------------------------------
# 7. Esperar rollouts
# -------------------------------------------------------------------
echo "Esperando despliegues (rollout)..."

for svc in auth-service device-management-service monitoring-service; do
  echo "⏳ rollout → $svc"
  if kubectl rollout status deployment/"$svc" --timeout=120s; then
    echo "  ✓ $svc desplegado correctamente"
  else
    echo "  ⚠ Advertencia: $svc NO completó rollout"
  fi
done

# -------------------------------------------------------------------
# 8. Obtener IP del ingress
# -------------------------------------------------------------------
echo "Obteniendo IP del ingress…"

sleep 3

IP=$(kubectl get ingress quadara-backend-ingress \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)

echo ""
echo "==================================="
echo "      🚀 DEPLOY COMPLETADO"
echo "==================================="

if [[ -z "$IP" ]]; then
  echo "Ingress IP: <pending>"
  echo "Revisa con: kubectl get ingress -n default"
else
  echo "Ingress IP disponible: $IP"
  echo ""
  echo "Pruebas:"
  echo "  curl http://$IP/auth/healthz"
  echo "  curl http://$IP/device/healthz"
  echo "  curl http://$IP/monitoring/healthz"
fi

echo "==================================="
