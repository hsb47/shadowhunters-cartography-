# GCP Ingestion Guide

## Required GCP Read-Only Roles

Cartography requires read-only IAM permissions for GCP asset ingestion. Recommended GCP IAM roles:

- `roles/viewer` (Project Viewer)
- `roles/browser` (Browser)
- `roles/iam.securityReviewer` (Security Reviewer)

## GCP Identity Data Flow

```
GCP Credentials (GOOGLE_APPLICATION_CREDENTIALS or gcloud ADC)
    ↓
GCP Service Account / User Identity
    ↓
GCP Resource APIs (Compute Engine, Storage, IAM)
    ↓
Cartography GCP Module (`--selected-modules gcp`)
    ↓
Neo4j Graph Database
```

## Running GCP Ingestion

```powershell
# Set credentials
$env:GCP_PROJECT_ID = "my-project-id"
$env:SHADOWHUNTERS_NEO4J_PASSWORD = "my-password"

# Execute runner
.\scripts\run-gcp.ps1
```
