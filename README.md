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

`terraform apply` is gated behind milestone GOU-10. Running `init` requires Application Default Credentials:

```sh
gcloud auth application-default login
```
