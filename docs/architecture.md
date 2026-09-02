# ShadowHunters System Architecture

The **ShadowHunters** multi-cloud security graph pipeline connects existing cloud environments to a central Neo4j database using Cartography as the ingestion engine.

```
+------------------------+      +------------------------+
|   AWS Infrastructure   |      |   GCP Infrastructure   |
| (EC2, S3, IAM, VPC...) |      | (VMs, Buckets, SA...)  |
+-----------+------------+      +-----------+------------+
            |                               |
            | read-only API                 | read-only API
            v                               v
+-----------+------------+      +-----------+------------+
| Cartography AWS Module |      | Cartography GCP Module |
+-----------+------------+      +-----------+------------+
            |                               |
            +---------------+---------------+
                            |
                            v
                +-----------+------------+
                |      Neo4j Database    |
                |   (bolt://localhost)   |
                +-----------+------------+
                            |
                            v
                +-----------+------------+
                | Security Analysis      |
                | - Schema Discovery     |
                | - Verification         |
                | - Cypher Exposure      |
                | - Candidate AttackPath |
                +------------------------+
```

## Core Architectural Components

1. **Ingestion Layer**: Cartography v0.140.0 fetches metadata from AWS and GCP APIs using standard SDK credentials (`boto3`, `google-api-python-client`).
2. **Graph Storage**: Neo4j Community Server stores assets as nodes and relationships as edges.
3. **Validation & Inspection**: PowerShell scripts (`check-environment.ps1`, `inspect-schema.ps1`, `verify-ingestion.ps1`) validate environment state and inspect real graph schema.
4. **Security Analysis Layer**: Bounded Cypher queries extract exposure patterns, IAM permissions, and candidate attack path chains.
