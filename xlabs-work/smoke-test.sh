#!/usr/bin/env sh
set -eu

FRONTEND_URL="${FRONTEND_URL:-http://localhost:3000}"
BACKEND_URL="${BACKEND_URL:-http://localhost:8000}"

echo "Checking backend health..."
curl -fsS "$BACKEND_URL/health"

echo "Checking frontend..."
curl -fsSI "$FRONTEND_URL"

echo "Checking database-backed backend path..."
curl -fsS "$BACKEND_URL/history"

echo "Smoke test passed."
