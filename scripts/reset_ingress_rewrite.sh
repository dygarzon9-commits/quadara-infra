#!/usr/bin/env bash
set -euo pipefail
kubectl delete ingress quadara-backend-ingress --ignore-not-found
cat > k8s/backend/ingress.yaml <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: quadara-backend-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /auth
        pathType: Prefix
        backend:
          service:
            name: auth-service
            port: { number: 80 }
      - path: /device
        pathType: Prefix
        backend:
          service:
            name: device-management-service
            port: { number: 80 }
      - path: /monitor
        pathType: Prefix
        backend:
          service:
            name: monitoring-service
            port: { number: 80 }
YAML
kubectl apply -f k8s/backend/ingress.yaml
