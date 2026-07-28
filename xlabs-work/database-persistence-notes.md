# Database Persistence Notes

Current workload file: k8s/10-database.yaml
Current workload type: Deployment
Database workload name: news-mongo
Database image: mongo:7
MongoDB internal data path: /data/db
Current Kubernetes mount for /data/db: missing
Production-readiness change: replace MongoDB Deployment with StatefulSet

Why this matters:
MongoDB writes database files under /data/db. The path exists inside the container, but Kubernetes must mount persistent storage there before pod replacement can preserve data.

StatefulSet design:
StatefulSet name: news-mongo
Expected pod name: news-mongo-0
Service name: news-mongo
Volume claim template name: mongo-data
Expected PVC name: mongo-data-news-mongo-0
Mount path: /data/db

Recovery marker:
Collection: readiness_marker
Document id: phase-6
Expected note: statefulset pvc survives pod replacement
