#!/bin/bash
set -a
[ -f .env ] && . .env
set +a

if [ -z "$DASHBOARD_TOKEN" ]; then
    echo "Error: DASHBOARD_TOKEN is not set in .env"
    exit 1
fi

envsubst '$DASHBOARD_TOKEN' < portal/portal-ingress.yaml | kubectl apply -f -

# 以下のコマンドで更新を即時反映
kubectl rollout restart deployment/portal -n portal
