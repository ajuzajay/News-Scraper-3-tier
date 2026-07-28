# Probe Plan

Frontend workload file: k8s/30-frontend.yaml
Frontend probe path: /
Frontend probe port before non-root image: 80
Frontend probe port after Phase 7 non-root image: 8080

Backend source file: backend/main.py
Backend workload file: k8s/20-backend.yaml
Backend probe path: /health
Backend probe port: 8000

Probe design note:
Probes should be lightweight. The scraper search endpoint should not be used as a probe.
