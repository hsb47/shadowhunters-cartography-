# ShadowHunters Prerequisites & Setup

## Tooling Requirements

1. **Python 3.12+ / Cartography v0.140.0**: Installed in your virtual environment (`.venv`) or system `PATH`.
2. **Neo4j Database Server**: Running locally on `bolt://localhost:7687` (requires Java JDK 21+ for Neo4j Community Server).
3. **PowerShell 5.1 / 7+**: Used for execution scripts on Windows/Cross-Platform shell.
4. **Cloud Credentials**: Read-only credentials configured for AWS and GCP.

## Environment Variable Configuration

Cartography and the runner scripts use the following environment variables:

| Variable | Description | Example |
|---|---|---|
| `AWS_PROFILE` | AWS CLI named profile | `default` |
| `AWS_DEFAULT_REGION` | Target AWS region | `us-east-1` |
| `GCP_PROJECT_ID` | Target GCP project | `my-gcp-project` |
| `GOOGLE_APPLICATION_CREDENTIALS` | Path to service account JSON key | `/keys/gcp-sa.json` |
| `NEO4J_URI` | Neo4j Bolt connection string | `bolt://localhost:7687` |
| `NEO4J_USER` | Neo4j username | `neo4j` |
| `SHADOWHUNTERS_NEO4J_PASSWORD` | Password passed to Cartography | `your-secure-password` |
