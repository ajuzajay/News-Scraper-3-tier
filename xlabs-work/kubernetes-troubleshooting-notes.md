# Kubernetes Troubleshooting Notes

## What Broke
bad image tag also one of the reason to broke the deployment

___

The backend could not connect to MongoDB because the ConfigMap contained an incorrect MongoDB connection URL:
MONGO_URL=mongodb://news-mongo-break:27017

As a result, API requests that accessed the database (/history and /search) returned HTTP 500 Internal Server Error.

## Which Command Showed the Symptom
Verified the application failure by calling the backend endpoint:

curl http://localhost:8000/history

The response returned:
- HTTP 500 Internal Server Error

## Which Command Showed the Cause
Checked the backend logs:

kubectl logs -n news-scraper deployment/news-backend

Verified the backend was using the incorrect environment variable:

kubectl exec -it <backend-pod-name> -n news-scraper -- printenv | grep MONGO

Output showed:

MONGO_URL=mongodb://news-mongo-break:27017

This confirmed the backend received the incorrect database URL from the ConfigMap.

## Which Command Restored the App
Updated the ConfigMap with the correct MongoDB URL:

MONGO_URL=mongodb://news-mongo:27017

Applied the ConfigMap:

kubectl apply -f k8s/05-configmap.yaml

Restarted the backend Deployment:

kubectl rollout restart deployment/news-backend -n news-scraper

Verified the rollout:

kubectl rollout status deployment/news-backend -n news-scraper

## Production Incident Evidence
During a real production incident, collect the following evidence:

- kubectl get pods -n news-scraper
- kubectl describe pod <backend-pod> -n news-scraper
- kubectl logs deployment/news-backend -n news-scraper
- kubectl get events -n news-scraper --sort-by=.metadata.creationTimestamp
- kubectl exec -it <backend-pod> -n news-scraper -- printenv | grep MONGO
- curl http://localhost:8000/health
- curl http://localhost:8000/history
- kubectl get configmap news-scraper-config -n news-scraper -o yaml
