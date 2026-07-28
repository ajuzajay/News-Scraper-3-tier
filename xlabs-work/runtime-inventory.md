# News Scraper Runtime Inventory

## Story
A previous DevOps engineer left after handing over this app. This file records what exists today before we turn it into a production-grade Kubernetes project.

---

## Frontend
- **Directory:** `frontend/`
- **Type:** Static HTML/CSS/JavaScript
- **Package manager:** None
- **Install command:** None
- **Build command:** None
- **Served by:** NGINX
- **Browser port:** 8080
- **Backend API URL:** `http://localhost:8000`
- **Kubernetes risk:** Hardcoded `localhost` will not work in Kubernetes. The frontend should call the backend through a Kubernetes Service (for example, `http://backend-service:8000`) or an Ingress.

---

## Backend API
- **Directory:** `backend/`
- **Framework:** FastAPI
- **Dependency file:** `backend/requirements.txt`
- **Expected start command:** `uvicorn main:app --host 0.0.0.0 --port 8000`
- **API port:** 8000
- **Search endpoint:** `GET /search?topic=<topic>`
- **History endpoint:** `GET /history`
- **Database setting:** `MONGO_URL`

---

## Scraper
- **Location:** `backend/scraper.py`
- **Trigger model:** Called by the FastAPI backend when the requested topic is not found in MongoDB.
- **External source:** Bing News
- **Output stored in:** MongoDB (`news_app.news` collection)

---

## Database
- **Engine:** MongoDB
- **Compose service name:** `mongo`
- **Connection variable:** `MONGO_URL`
- **Default connection URL:** `mongodb://mongo:27017`
- **Database name:** `news_app`
- **Collection name:** `news`
- **Stored fields:**
  - `topic`
  - `results`
  - `created_at`

---

## Service Communication
- **User browser → Frontend:** HTTP request to NGINX on port **8080**
- **Frontend → Backend:** HTTP GET requests (`/search` and `/history`)
- **Backend → Database:** Uses PyMongo (`MongoClient`) via `MONGO_URL`
- **Backend → Scraper:** Imports and calls `scrape_news()` from `scraper.py`
- **Scraper → External news source:** Sends HTTP requests to Bing News and parses responses using BeautifulSoup
- **Backend/Scraper → Database:** Stores scraped results in the `news` collection

---

## Production Readiness Gaps
- **Docker images needed:**
  - Backend (Python + FastAPI)
  - Frontend (NGINX serving static files)
  - MongoDB (official image)

- **Compose runtime needed:**
  - Multi-container setup with backend, frontend, and MongoDB

- **Kubernetes manifests needed:**
  - Deployments
  - Services
  - PersistentVolume (PV)
  - PersistentVolumeClaim (PVC)
  - ConfigMap
  - Secret
  - Ingress (optional)

- **Runtime config needed:**
  - `MONGO_URL`
  - Backend API URL
  - Container ports

- **Secrets needed:**
  - MongoDB credentials (if authentication is enabled)

- **Persistence needed:**
  - Persistent volume for MongoDB data

- **Probes needed:**
  - Liveness probe
  - Readiness probe

- **Observability evidence needed:**
  - Application logs
  - Container logs
  - Health endpoints
  - Metrics (Prometheus/Grafana optional)

- **CI/CD needed:**
  - Build Docker images
  - Run automated tests
  - Push images to a registry
  - Deploy to Kubernetes
  - Smoke tests after deployment
