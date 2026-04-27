# data-platform

Data-engineering side of the **GitHub Velocity Analytics Pipeline** project. Owns extraction (dlt), orchestration (Dagster), Iceberg registration (PyIceberg), shared utilities, and infrastructure (Terraform).

The companion repo, `analytics-engineering`, owns the dbt models and Streamlit dashboards.

## Project context

We measure whether open-source development velocity changed after the release of Claude Opus 4.6 on Feb 5, 2026 by comparing GitHub activity for 20 stratified-sample repositories against the equivalent period one year prior.

Authoritative docs (in `data-eng-vault`):

- PRD: `Github Analytics Pipeline/github-velocity-prd.md`
- Decisions log: `Github Analytics Pipeline/decisions/DECISIONS.md`
- Linear project: *GitHub Velocity Analytics Pipeline* (ticket prefix `GOU-`)

## Layout

```
infra/                 Terraform — GCP buckets, IAM, secrets, Cloud Run
  modules/             Reusable resource blueprints
  environments/        Concrete dev/prod call sites
```

Python (`shared/`, `pipelines/`) lands in milestone M1.

## Infrastructure usage

GCP project: `data-engineering-494500`. Terraform state in `gs://data-engineering-terraform/`.

Per environment:

```sh
cd infra/environments/dev    # or prod
terraform init
terraform plan
```

Running `init` requires Application Default Credentials:

```sh
gcloud auth application-default login
```

Dev infrastructure has been applied (M0). Prod is provisioned in code but not yet applied.

## Local development

Application code (dlt, Dagster, etc.) runs as the pipeline writer service account via **impersonation** — no JSON key files on disk. Secrets (e.g. the GitHub PAT) live only in Secret Manager and are fetched at runtime.

### Setup

```sh
cp .env.example .env       # then edit .env if your impersonation principal differs
```

Source the env however you prefer (`source .env`, `direnv allow`, your IDE's env loader, etc.). The committed `.env.example` documents every required variable; `.env` itself is gitignored.

### How secrets are read

`.env` only contains the secret's *resource path*, not its value. Application code resolves it at runtime:

```python
import os
from google.cloud import secretmanager

client = secretmanager.SecretManagerServiceClient()
response = client.access_secret_version(name=os.environ["GITHUB_PAT_SECRET"])
github_pat = response.payload.data.decode()
```

This works identically in three environments:

| Environment | Authentication path |
|---|---|
| Local dev | ADC base identity → impersonates writer SA → reads Secret Manager |
| GitHub Actions CI | OIDC token → impersonates writer SA → reads Secret Manager |
| Cloud Run (M7+) | Workload Identity → runs as writer SA directly → reads Secret Manager |

No code branches per environment; the `GOOGLE_IMPERSONATE_SERVICE_ACCOUNT` env var only differs locally vs prod.

### Rotating the GitHub PAT

```sh
echo -n "ghp_NEW_PAT_VALUE" | gcloud secrets versions add github-pat-dev \
    --data-file=- --project=data-engineering-494500

# Disable the old version (or `destroy` to make it unrecoverable)
gcloud secrets versions disable <old-version-number> \
    --secret=github-pat-dev --project=data-engineering-494500
```

Application code reads `versions/latest` and picks up the new value automatically.
