Quadara – Deployment & CI/CD Documentation (v0.1.0)
1. Objetivo del documento

Este documento describe la versión inicial funcional de la plataforma Quadara, incluyendo:

Infraestructura como Código (Terraform)

Backend en Kubernetes (AKS)

Base de datos PostgreSQL

Ingress NGINX

Pipeline CI/CD con GitHub Actions

Flujo completo de despliegue automatizado

El objetivo es que cualquier persona del equipo pueda reproducir, entender y operar el sistema sin conocimiento previo del entorno.

2. Arquitectura general
Componentes principales

Azure Resource Group

Azure Kubernetes Service (AKS)

Load Balancer Standard

NGINX Ingress Controller

Azure Container Registry (ACR)

PostgreSQL Flexible Server

GitHub Actions (CI/CD)

Diagrama lógico (simplificado)
GitHub Repo
   |
   | push (main)
   v
GitHub Actions
   ├─ CI: Build imágenes → ACR
   └─ CD: Deploy → AKS
                  |
                  v
            Ingress NGINX
                  |
      ┌───────────┼───────────┐
      v           v           v
 auth-service  device-mgmt  monitoring
                  |
                  v
           PostgreSQL (Azure)

3. Infraestructura (Terraform)
Ubicación
terraform/

Recursos creados

Resource Group

AKS Cluster

ACR

PostgreSQL Flexible Server

Base de datos quadara_db

Key Vault

Storage Account (reservado para frontend futuro)

Variables principales
resource_group_name = "ParentalControl-RG"
location            = "centralus"
aks_name            = "parental-control-aks"
acr_name            = "quadaraacr"
pg_server_name      = "parental-control-db"
db_admin_user       = "pgadmin"

Ejecución
cd terraform
terraform init
terraform apply

4. Base de datos

Motor: PostgreSQL Flexible Server

Versión: 15

Servidor: parental-control-db.postgres.database.azure.com

Base de datos: quadara_db

Acceso: SSL requerido

⚠️ El firewall del servidor permite acceso desde Azure (0.0.0.0), recomendado solo para entornos iniciales.

5. Backend (Kubernetes)
Servicios desplegados
Servicio	Descripción
auth-service	Autenticación
device-management-service	Gestión de dispositivos
monitoring-service	Estado y monitoreo
Ubicación del código
backend/
k8s/backend/

Manifests Kubernetes

deployments.yaml

ingress.yaml

6. Ingress & Endpoints
Ingress

Tipo: NGINX

Exposición: LoadBalancer (IP pública)

Namespace: default

Endpoints disponibles
/auth/healthz
/device/healthz
/monitoring/healthz


Ejemplo de prueba:

curl http://<INGRESS_IP>/auth/healthz


Respuesta esperada:

{"ok": true}

7. CI/CD – GitHub Actions
Ubicación
.github/workflows/

7.1 CI – Build backend images

Archivo: ci-build.yml

Trigger:

Push a main

Cambios en backend/**

Qué hace:

Login a Azure vía OIDC

Build de imágenes Docker

Push automático a ACR

7.2 CD – Deploy backend to AKS

Archivo: cd-deploy.yml

Trigger:

Push a main

Cambios en backend/** o k8s/**

Qué hace:

Login a Azure (OIDC)

Obtener credenciales de AKS

Sustituir ACR en manifests

Aplicar manifests

Esperar rollout

Mostrar IP del Ingress

8. Secrets requeridos en GitHub

Configurar en:

Settings → Secrets and variables → Actions

Secret	Descripción
AZURE_CLIENT_ID	App Registration (OIDC)
AZURE_TENANT_ID	Tenant ID
AZURE_SUBSCRIPTION_ID	Subscription
RESOURCE_GROUP	RG del AKS
AKS_NAME	Nombre del cluster
ACR_NAME	Nombre del ACR
9. Flujo completo de despliegue
git push main
   ↓
CI: Build imágenes (ACR)
   ↓
CD: Deploy en AKS
   ↓
Servicios disponibles vía Ingress


👉 No se requieren comandos manuales

10. Validación rápida
kubectl get pods
kubectl get ingress

curl http://<INGRESS_IP>/auth/healthz
curl http://<INGRESS_IP>/device/healthz
curl http://<INGRESS_IP>/monitoring/healthz

11. Estado actual del proyecto

✅ Infraestructura estable

✅ CI/CD funcional

✅ Backend desplegado

✅ Base de datos creada

✅ Ingress operativo

Versión: v0.1.0 – Initial functional version

12. Próximos pasos sugeridos

Diseño de esquema de base de datos

Autenticación real (JWT / OAuth)

HTTPS + dominio

Frontend

Observabilidad (logs, métricas)

Tests automatizados

13. Contacto / Ownership

Repositorio mantenido por el equipo Quadara.
Este documento describe la línea base oficial del sistema.
