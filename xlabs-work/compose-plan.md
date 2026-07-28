# News Scraper Compose Plan

## Frontend Service
- Service name: frontend
- Image: news-frontend:latest
- Host port: 8080
- Container port: 80
- Browser API URL: http://localhost:8000

## Backend Service
- Service name: backend
- Image: news-backend:latest
- Host port: 8000
- Container port: 8000
- Database environment variable: MONGO_URL
- Database URL: mongodb://mongo:27017

## Database Service
- Service name: mongo
- Image: mongo:latest
- Container port: 27017
- Volume name: mongo-data

## Scraper Behavior
- Separate service needed: No
- Reason: The scraper is a Python module (`scraper.py`) imported and executed by the FastAPI backend. It is not an independent application or container.

## Service Communication
- Browser -> frontend: HTTP (http://localhost:8080)
- Browser -> backend: HTTP GET requests sent by app.js to http://localhost:8000
- Backend -> MongoDB: Via MONGO_URL (mongodb://mongo:27017)
- Backend -> scraper function: Calls scrape_news() imported from scraper.py
