#!/usr/bin/env bash

# Create a dedicated Docker network for all expense-tracker components
docker network create expense-tracker

# Start a PostgreSQL container with a named volume for persistent data
# Mount initialization SQL scripts from ./db (read-only)
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
  
  docker run --mount type=volume,source=expense-tracker-db-vol,target=/var/lib/postgresql/data -v "$(pwd)/db:/docker-entrypoint-initdb.d:ro" -e POSTGRES_PASSWORD=top-secret -e POSTGRES_DB=expense_tracker -e POSTGRES_USER=expense_tracker --name expense-db --network expense-tracker -d postgres:17

# Build the backend image from the ./backend directory                                                  -v "$(pwd)/db:/docker-entrypoint-initdb.d:ro"
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
=======================
# #This PowerShell command reads your original SQL file and creates a new version encoded as UTF-8.
# Get-Content .\db\init.sql | Set-Content -Encoding UTF8 .\db\init-fixed.sql

# After this:

# init-fixed.sql is UTF-8 encoded ✅

# You can safely rename it back to init.sql:

# Move-Item -Force .\db\init-fixed.sql .\db\init.sql
# Use full:
# 🧩 Step-by-step:

# Get-Content .\db\init.sql
# → Reads the contents of the file init.sql (in your db folder).

# | (the pipe)
# → Sends that content to the next command in the pipeline.

# Set-Content -Encoding UTF8 .\db\init-fixed.sql
# → Writes the content into a new file called init-fixed.sql, and forces the encoding to UTF-8.
 #====================
 On Windows PowerShell:
 #to activate in window powershell
 .\env\Scripts\Activate   
 #activate  On Linux/macOS:
 source venv/bin/activate

#Create virtual environment
 python -m venv venv

#Install dependencies:
 pip install -r requirements.txt   or pip install -r backend\requirements.txt

#  #to creat table in db:
#   docker exec -it expense-db bash

#   #psql -U auth_user -d your_db

#    psql -U  expense_tracker -d expense-db

#    #Connect to your new database
#    \c "expense-db" expense_tracker

#   # Create tables (example schema)
#   -- Users table
# CREATE TABLE users (
#     id SERIAL PRIMARY KEY,
#     username VARCHAR(50) UNIQUE NOT NULL,
#     email VARCHAR(100) UNIQUE NOT NULL,
#     password VARCHAR(255) NOT NULL,
#     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
# );

#  Expenses table
# CREATE TABLE expenses (
#     id SERIAL PRIMARY KEY,
#     user_id INT REFERENCES users(id),
#     title VARCHAR(255) NOT NULL,
#     amount NUMERIC(10,2) NOT NULL,
#     category VARCHAR(100),
#     expense_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
# );

# #Verify tables:
#   \dt




