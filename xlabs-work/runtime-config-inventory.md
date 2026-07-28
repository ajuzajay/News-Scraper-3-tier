# Runtime Configuration Inventory

## ConfigMap Values
- APP_ENV: local
- MONGO_URL: mongodb://news-mongo:27017
- MONGO_DATABASE: news_app
- FRONTEND_API_BASE_URL: http://news-backend:8000

## Secret Values
- SCRAPER_API_TOKEN: Placeholder (not currently used)

## Current Hardcoded Values To Remove
- Backend Deployment:
  - MONGO_URL (should come from ConfigMap)
  - MONGO_DATABASE (should come from ConfigMap)
- Frontend Deployment:
  - Backend API URL (currently hardcoded in app.js as http://localhost:8000)

## Notes
- `MONGO_URL` should come from a ConfigMap in Kubernetes.
- Placeholder tokens can use a Secret in this project, but real production secrets need a stronger secrets-management process.
