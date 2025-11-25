#!/usr/bin/env bash

echo "🧹 Stopping and removing containers..."
docker container rm -f expense-frontend-container || true
docker container rm -f expense-backend-container || true
docker container rm -f expense-db || true

echo "📦 Removing Docker images..."
docker image rm -f expense-frontend || true
docker image rm -f expense-backend || true

echo "🗑️ Removing Docker volume..."
docker volume rm expense-tracker-db-vol || true

echo "🌐 Removing Docker network..."
docker network rm expense-tracker || true

echo "✅ Cleanup complete."
