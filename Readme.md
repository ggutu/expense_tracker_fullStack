# 🧾 Expense Tracker (Dockerized Full Stack Application)

This project is a **three-tier containerized web application** that allows users to track and manage expenses.  
It includes a **PostgreSQL database**, a **FastAPI backend**, and a **frontend web interface** — all running in isolated Docker containers connected through a shared Docker network.

---

## 🏗️ Project Architecture

frontend (React/Vite)
↓
backend (FastAPI)
↓
database (PostgreSQL)




All services communicate over a custom Docker network named `expense-tracker`.

---

## 🚀 Setup Instructions

### 1️⃣ Create a Dedicated Docker Network

This network allows the backend and frontend containers to communicate with the database.

```bash
docker network create expense-tracker
2️⃣ Start PostgreSQL Database
Create a PostgreSQL container with persistent storage and an initialization SQL script.

bash
docker run \
  --mount type=volume,source=expense-tracker-db-vol,target=/var/lib/postgresql/data \
  -v "$(pwd)/db":/docker-entrypoint-initdb.d:ro \
  -e POSTGRES_PASSWORD=top-secret \
  -e POSTGRES_DB=expense_tracker \
  -e POSTGRES_USER=expense_tracker \
  --name expense-db \
  --network expense-tracker \
  -d \
  postgres:17
✅ Explanation:

expense-tracker-db-vol — Persistent volume for database data

./db — Local directory containing initialization SQL scripts

POSTGRES_* — Environment variables for credentials and database setup

Container name: expense-db

3️⃣ Build and Run the FastAPI Backend
Build the backend Docker image from the ./backend directory:

bash
docker build -t expense-backend ./backend
Run the backend container on port 8080, connected to the same network:

bash
docker container run \
  --name expense-backend-container \
  --network expense-tracker \
  -p 8080:5001 \
  -e DATABASE_HOST=expense-db \
  -d \
  expense-backend
✅ Explanation:

DATABASE_HOST=expense-db — Connects backend to the running PostgreSQL container

-p 8080:5001 — Maps container port 5001 to local port 8080

4️⃣ Build and Run the Frontend
Build the frontend image with the API base URL passed as a build argument:

bash
docker build -t expense-frontend \
  --build-arg VITE_API_BASE_URL=http://localhost:8080/api \
  ./frontend
Run the frontend container on port 8081:

bash
docker container run \
  --name expense-frontend-container \
  --network expense-tracker \
  -p 8081:80 \
  -d \
  expense-frontend
✅ Explanation:

Frontend connects to backend through http://localhost:8080/api

Port 8081 serves the web UI