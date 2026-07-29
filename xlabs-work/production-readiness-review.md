- Application ownership summary.
- Runtime topology.
- Container images.
- Compose runtime.
- Kubernetes workloads and Services.
- Runtime configuration and Secrets.
- Database persistence.
- Health probes.
- Resource and security controls.
- Troubleshooting and rollback.
- Kustomize packaging.
- Base versus overlay responsibility.
- Environment promotion model.
- CI evidence.
- OS-specific CI workflow selected.
- CD evidence.
- OS-specific CD workflow selected.
- Dev versus QA image promotion behavior.
- Local Kind limitations.
- Cloud Kubernetes next steps.

## Architecture Review

### Frontend entry path

* User opens the web UI through the frontend Service.
* Browser request: `http://localhost:8080`
* Frontend is served by **NGINX**.
* Static files served: `index.html`, `app.js`, and `style.css`.

### Backend API path

* Frontend JavaScript sends requests to the backend.
* API endpoints:

  * `GET /health`
  * `GET /history`
  * `GET /search?topic=<topic>`
* Backend runs on **FastAPI (Uvicorn)** and listens on **port 8000**.

### Database dependency

* Backend connects to **MongoDB**.
* Connection URL is provided through the **ConfigMap**.
* Backend reads the `MONGO_URL` environment variable and uses it to create the MongoDB client.

### Scraper or worker behavior

* There is **no separate scraper service**.
* `scraper.py` is imported by the backend.
* When `/search` is called:

  * Backend checks MongoDB.
  * If cached data exists, it returns the cached result.
  * Otherwise, it runs the scraper, stores the result in MongoDB, and returns the response.

### ConfigMap and Secret usage

**ConfigMap**

* `APP_ENV`
* `MONGO_URL`
* `MONGO_DATABASE`
* `FRONTEND_API_BASE_URL`

**Secret**

* `SCRAPER_API_TOKEN`

ConfigMap stores runtime configuration, while Secret stores sensitive values.

### PVC usage

MongoDB runs as a **StatefulSet**.

Persistent data is stored using a **PersistentVolumeClaim (PVC)** mounted at:

`/data/db`

This allows MongoDB data to survive Pod recreation and node rescheduling.

### Probe coverage

**Frontend**

* Readiness probe
* Liveness probe

**Backend**

* Startup probe
* Readiness probe
* Liveness probe

Current probes validate the `/health` endpoint.

### CI/CD image flow

CI builds Docker images and runs smoke validation.

Images are tagged with environment-specific commit SHA tags:

* `dev-<commit-sha>`
* `qa-<commit-sha>`

Validated images are then deployed by the CD workflow.

### OS-specific workflow path

**Linux/macOS**

* CI: `.github/workflows/ci.yml`
* CD: `.github/workflows/cd-local-kind-unix.yml`

**Windows**

* CI: `.github/workflows/ci-windows.yml`
* CD: `.github/workflows/cd-local-kind-windows.yml`

### Workflow pairing

Correct GitHub Actions pairing:

**Unix**

* CI workflow name: `CI`
* Unix CD listens for: `CI`

**Windows**

* CI workflow name: `CI Windows`
* Windows CD listens for: `CI Windows`

The CD workflow must listen to the matching CI workflow name.

### Kustomize environment flow

Base manifests:

`k8s/base`

Environment overlays:

`k8s/overlays/dev`

`k8s/overlays/qa`

Deployment flow:

Base → Dev Overlay → QA Overlay

The overlays apply environment-specific configuration without duplicating the base manifests.

### Image tagging strategy

**Development**

`news-scraper-backend:dev-<commit-sha>`

`news-scraper-frontend:dev-<commit-sha>`

**QA**

`news-scraper-backend:qa-<commit-sha>`

`news-scraper-frontend:qa-<commit-sha>`

Using commit SHA tags creates immutable and traceable deployments.

### Why QA tags must only be published after CI smoke validation

Publishing QA images only after CI smoke validation ensures:

* The image can start successfully.
* The application responds correctly.
* Basic API functionality works.
* Broken images are prevented from reaching QA.

This guarantees that QA testing always uses a verified build.

### Future promotion strategy

In a production project, the **same tested image tag** should be promoted through every environment:

Development → QA → Pre-Production → Production

Example:

`news-scraper-backend:qa-a1b2c3d`

That exact image should move through each environment without rebuilding.

This provides:

* Immutable deployments
* Full deployment traceability
* Reliable rollback capability
* Environment consistency
* Production confidence because the identical tested artifact reaches production

Cloud Readiness Gap

- Replace local PVC behavior with managed storage classes.
- Replace port-forward access with Ingress, DNS, and TLS.
- Move secrets to a stronger secrets-management path.
- Add centralized logs and metrics.
- Add environment-specific overlays.
- Promote the same tested image tag through dev, QA, pre-prod, and production overlays.
- Add backup and restore strategy.
- Add image scanning and policy checks.
