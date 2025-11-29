#  Expense Tracker (Dockerized Full Stack Application)

This project is a **three-tier containerized web application** that allows users to track and manage expenses.

It includes a **PostgreSQL database**, a **FastAPI backend**, and a **frontend web interface** — all running in isolated Docker containers connected through a shared Docker network.

## Project Architecture

frontend (React/Vite)
↓
backend (FastAPI)
↓
database (PostgreSQL)

### 1️⃣ Create a Dedicated Docker Network 
        docker network create expense-tracker

### 2️⃣ Create a PostgreSQL container with persistent     storage and an initialization SQL script ##

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

### 3️⃣ Build and Run the FastAPI Backend ###

    docker build -t expense-backend ./backend

###### Run the FastAPI backend container, connecting to the same network and exposing port 5001 docker container run ######

     docker container run \
        --name expense-backend-container \
        --network expense-tracker \
        -p 8080:5001 \
        -e DATABASE_HOST=expense-db \
        -d \
         expense-backend*
  
### 4️⃣ Build and Run the Frontend 
### Build the frontend image with the API base URL passed as a build argument:###

      docker build -t expense-frontend \
         --build-arg VITE_API_BASE_URL=http:localhost:8080/api \
         ./frontend

### Run the frontend container on port 8081:###

      docker container run \
        --name expense-frontend-container \
        --network expense-tracker \
        -p 8081:80 \
        -d \
        expense-frontend
  