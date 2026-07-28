

## Namespace
- Namespace: news-scraper

## Frontend
- Compose service: frontend
- Kubernetes Deployment: create a deployment
- Kubernetes Service: create a service file
- Container port: 80
- Host access method: 8080

## Backend
- Compose service: backend
- Kubernetes Deployment: 
- Kubernetes Service:
- Container port: 8000
- Database URL: 

## Database
- Compose service:
- Kubernetes Deployment:
- Kubernetes Service:
- Container port:
- Persistence in this phase:

## Notes
- Baseline phase uses simple manifests first.
# News Scraper Kubernetes Baseline Map

## Namespace
- Namespace: news-scraper

## Frontend
- Compose service: frontend
- Kubernetes Deployment: frontend-deployment
- Kubernetes Service: frontend-service
- Container port: 80
- Host access method: NodePort (or port-forward during development)

## Backend
- Compose service: backend
- Kubernetes Deployment: backend-deployment
- Kubernetes Service: backend-service
- Container port: 8000
- Database URL: mongodb://mongo-service:27017

## Database
- Compose service: mongo
- Kubernetes Deployment: mongo-deployment
- Kubernetes Service: mongo-service
- Container port: 27017
- Persistence in this phase: None (ephemeral storage only)

## Notes
- Baseline phase uses simple manifests first.
- Persistence, probes, hardening, and Kustomize come later.
