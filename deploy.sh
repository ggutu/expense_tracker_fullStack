#!/usr/bin/env bash

# Create a dedicated Docker network for all expense-tracker components
docker network create expense-tracker

# Start a PostgreSQL container with a named volume for persistent data
# Mount initialization SQL scripts from ./db (read-only)
docker container run \
  --mount type=volume,source=expense-tracker-db-vol,target=/var/lib/postgresql/data \
  -v "$(pwd)/db":/docker-entrypoint-initdb.d:ro \
  -e POSTGRES_PASSWORD=top-secret \
  -e POSTGRES_DB=expense_tracker \
  -e POSTGRES_USER=expense_tracker \
  --name expense-db \
  --network expense-tracker \
  -d \
  postgres:17
  
  docker run --mount type=volume,source=expense-tracker-db-vol,target=/var/lib/postgresql/data -v "$(pwd)/db:/docker-entrypoint-initdb.d:ro" -e POSTGRES_PASSWORD=top-secret -e POSTGRES_DB=expense_tracker -e POSTGRES_USER=expense_tracker --name expense-db --network expense-tracker -d postgres:17

# Build the backend image from the ./backend directory
docker build -t expense-backend ./backend

# Run the FastAPI backend container, connecting to the same network and exposing port 5001
docker container run \
  --name expense-backend-container \
  --network expense-tracker \
  -p 8080:5001 \
  -e DATABASE_HOST=expense-db \
  -d \
  expense-backend

  #docker container run --name expense-backend-container --network expense-tracker -p 8080:5001 -e DATABASE_HOST=expense-db -d expense-backend
docker container run --name expense-backend-container --network expense-tracker -p 8080:5001 -e DATABASE_HOST=expense-db -d expense-backend

# Build the frontend image from the ./frontend directory, injecting the API base URL
docker build -t expense-frontend \
  --build-arg VITE_API_BASE_URL=http://localhost:8080/api \
  ./frontend
  #docker build -t expense-frontend --build-arg VITE_API_BASE_URL=http://localhost:8080/api ./frontend

# Run the frontend container, exposing it on port 8081
docker container run \
  --name expense-frontend-container \
  --network expense-tracker \
  -p 8081:80 \
  -d \
  expense-frontend

 # docker container run --name expense-frontend-container --network expense-tracker -p 8081:80 -d expense-frontend