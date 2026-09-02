# AWS Ingestion Guide

## Required AWS Read-Only Permissions

Cartography requires read-only discovery permissions to query AWS services. Recommended policy attachment:

- `SecurityAudit` (AWS Managed Policy)
- `ReadOnlyAccess` (AWS Managed Policy)

## AWS Identity Data Flow

```
AWS Credentials (~/.aws/credentials or AWS_PROFILE)
    ↓
AWS IAM Principal Identity
    ↓
AWS Read-Only Discovery APIs (ec2:Describe*, s3:List*, iam:Get*)
    ↓
Cartography AWS Module (`--selected-modules aws`)
    ↓
Neo4j Graph Database
```

## Running AWS Ingestion

```powershell
# Set credentials
$env:AWS_PROFILE = "my-profile"
$env:AWS_DEFAULT_REGION = "us-east-1"
$env:SHADOWHUNTERS_NEO4J_PASSWORD = "my-password"

# Execute runner
.\scripts\run-aws.ps1
```
