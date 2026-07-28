# News Scraper Containerization Plan

## Frontend Image
- Source directory: frontend/
- Runtime type: Static HTML/CSS/JavaScript
- Base image: nginx:alpine
- Dependency install needed: None
- Build command needed: None
- Container port: 80 (mapped to host port 8080 in Docker Compose)
- Start behavior: NGINX serves the static files (index.html, app.js, style.css)
- What this image should not contain:
  - Node.js
  - npm
  - package.json
  - Build tools
  - Application source that is not required at runtime
  - The container should run as a non-root user whenever possible for better security.

## Backend Image
- Source directory: backend/
- Runtime type: Python FastAPI API
- Base image: python:3.11-slim
- Dependency file: requirements.txt
- Dependency install location: backend/requirements.txt
- Container port: 8000
- Start command:
  uvicorn main:app --host 0.0.0.0 --port 8000
- Runtime values that should not be hardcoded:
  - MONGO_URL
  - MongoDB username (if authentication is enabled)
  - MongoDB password (if authentication is enabled)

## Docker-First Rule
- Backend dependencies must be installed during the Docker image build using requirements.txt, not directly on the developer's laptop.
- The frontend is a static website and should be served by NGINX without using Node.js, npm install, or a frontend build step.
