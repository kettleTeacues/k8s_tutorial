#!/bin/bash
set -a
[ -f .env ] && . .env
set +a

if [ -z "$JQUANTS_MAIL" ]; then
    echo "Error: JQUANTS_MAIL is not set in .env"
    exit 1
fi
if [ -z "$JQUANTS_PASS" ]; then
    echo "Error: JQUANTS_PASS is not set in .env"
    exit 1
fi
if [ -z "$PG_URL" ]; then
    echo "Error: PG_URL is not set in .env"
    exit 1
fi
if [ -z "$BACKEND_ENDPOINT" ]; then
    echo "Error: BACKEND_ENDPOINT is not set in .env"
    exit 1
fi

envsubst '$JQUANTS_MAIL $JQUANTS_PASS $PG_URL $BACKEND_ENDPOINT' < web/my_finance.yml | kubectl apply -f -
kubectl rollout restart deployment/backend-deployment
kubectl rollout restart deployment/frontend-deployment
