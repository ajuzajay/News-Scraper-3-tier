# CI Image Contract

- Dev backend image: ghcr.io/ajuzajay/news-scraper-backend:dev-<commit-sha>
- Dev frontend image: ghcr.io/ajuzajay/news-scraper-frontend:dev-<commit-sha>
- QA backend image: ghcr.io/ajuzajay/news-scraper-backend:qa-<commit-sha>
- QA frontend image: ghcr.io/ajuzajay/news-scraper-frontend:qa-<commit-sha>
- Dev images can be published before smoke validation so developers can deploy and debug.
- QA images are published only after smoke validation passes.
- Backend and frontend images built from the same commit SHA are considered one release pair.
- CD must never rebuild images; it should deploy the images produced by CI.
