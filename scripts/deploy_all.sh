#!/usr/bin/env bash
set -euo pipefail
bash scripts/generate_secure_env.sh
bash scripts/deploy_infra.sh
bash scripts/deploy_backend.sh
bash scripts/test_app_functional.sh
