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

envsubst '$JQUANTS_MAIL $JQUANTS_PASS $PG_URL' < crons/yf.yml | kubectl apply -f -
