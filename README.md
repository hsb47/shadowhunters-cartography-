# 🛡️ ShadowHunters: Multi-Cloud Cartography Security Graph

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Cartography](https://img.shields.io/badge/Cartography-v0.140.0-orange.svg)](https://github.com/lyft/cartography)
[![Neo4j](https://img.shields.io/badge/Neo4j-v5%2B-blue.svg)](https://neo4j.com/)
[![Python](https://img.shields.io/badge/Python-3.12%2B-green.svg)](https://www.python.org/)

**ShadowHunters** is an infrastructure security mapping and graph analysis platform. It ingests existing **AWS** and **GCP** cloud environments into **Neo4j** using **Cartography (v0.140.0)** to provide automated graph verification, security exposure analysis, and candidate attack-path queries.

---

## 📐 System Architecture

```
              EXISTING CLOUD INFRASTRUCTURE
                 /                  \
                /                    \
             AWS                      GCP
  (EC2, S3, IAM, VPC...)    (VMs, Buckets, SA...)
              │                        │
              │ read-only              │ read-only
              ▼                        ▼
        Cartography AWS          Cartography GCP
              │                        │
              └──────────┬─────────────┘
                         ▼
                      NEO4J
                 (Security Graph)
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
      Inventory       Exposure      Attack Paths
                                      │
                                      ▼
                              Security Findings
```

---

## 🎯 Key Features & Capabilities

- **Purely Read-Only Infrastructure Discovery**: Maps existing AWS and GCP resources without modifying, creating, or deleting cloud infrastructure or IAM policies.
- **Dynamic Executable & Environment Resolution**: Scripts auto-detect Python virtual environments (`.venv`), system `PATH`, and Neo4j endpoints dynamically without hardcoding machine-specific absolute paths.
- **Schema Discovery & Graph Inspection**: Includes an inline schema inspector (`scripts/inspect-schema.ps1`) to query real graph node labels and relationship types directly from the database.
- **Schema-Driven Security Queries**: Provides a structured Cypher query library (`queries/security/`) tailored to discovered graph schemas for IAM analysis, public exposures, and bounded attack paths.
- **Zero-Trust Secret Handling**: Equipped with strict `.gitignore` rules preventing accidental commits of API keys, AWS credentials, GCP service account JSONs, or local database logs.

---

## 🔐 Security & Risk Taxonomy

To maintain analytical accuracy, this repository strictly categorizes cloud graph findings into five security tiers:

| Tier | Category | Description | Example |
| :--- | :--- | :--- | :--- |
| **1** | **Inventory** | Mapping what resources exist in the environment | `AWSAccount`, `EC2Instance`, `S3Bucket`, `GCPProject`, `GCPServiceAccount` |
| **2** | **Exposure** | Network or storage resources reachable publicly | Security Group ingress `0.0.0.0/0`, public S3 / GCP Buckets |
| **3** | **Risky Permissions** | High-privilege policies or broad trust boundaries | `AdministratorAccess`, GCP `roles/owner`, cross-account assume-role |
| **4** | **Candidate Attack Paths** | Multi-hop graph relationship chains between nodes | Bounded path traversals connecting an exposed workload to sensitive assets |
| **5** | **Confirmed Vulnerabilities** | Requires external scanner proof (e.g. CVEs) | *Graph paths highlight structural risk chains; they are not automated exploit proofs* |

---

## 📁 Repository Structure

```
shadowhunters-cartography/
├── README.md                          # Comprehensive Technical Master Guide
├── LICENSE                            # Apache 2.0 Open Source License
├── .gitignore                         # Strict exclusion rules for secrets & logs
├── config/                            # Environment variable templates
│   ├── aws.example.env                # AWS Profile & Region template
│   ├── gcp.example.env                # GCP Project ID & ADC key template
│   └── neo4j.example.env              # Neo4j URI & Password env template
├── docs/                              # Detailed Technical Documentation
│   ├── architecture.md                # Component & data flow diagrams
│   ├── prerequisites.md               # Tooling & system requirements
│   ├── aws.md                         # AWS read-only permissions & setup
│   ├── gcp.md                         # GCP read-only permissions & setup
│   ├── neo4j.md                       # Neo4j administration & configuration
│   ├── security-analysis.md           # Query interpretation methodology
│   └── troubleshooting.md             # Common errors and resolutions
├── scripts/                           # PowerShell Execution & Inspection Suite
│   ├── check-environment.ps1          # Dynamic environment & credential check
│   ├── inspect-schema.ps1             # Graph schema & label discovery tool
│   ├── run-aws.ps1                    # Read-only AWS Cartography runner
│   ├── run-gcp.ps1                    # Read-only GCP Cartography runner
│   ├── run-all.ps1                    # Sequential multi-cloud runner
│   └── verify-ingestion.ps1           # Node & relationship count verifier
├── queries/                           # Cypher Query Library
│   ├── inventory/                     # Resource & relationship count queries
│   │   ├── node-counts.cypher
│   │   ├── relationship-counts.cypher
│   │   ├── aws-inventory.cypher
│   │   └── gcp-inventory.cypher
│   └── security/                      # Exposure, IAM, & attack-path queries
│       ├── aws-public-resources.cypher
│       ├── aws-iam-permissions.cypher
│       ├── gcp-public-resources.cypher
│       ├── gcp-iam-permissions.cypher
│       ├── attack-paths.cypher
│       └── cross-cloud.cypher
├── output/                            # Local execution logs & reports (Gitignored)
│   └── .gitkeep
├── reports/                           # Local security reports (Gitignored)
│   └── .gitkeep
├── tests/                             # Cypher query validation checklist
│   └── test_queries.md
└── examples/                          # Sanitized findings examples
    └── sample-findings.md
```

---

## 🚀 Reproduce the Demo (Step-by-Step Guide)

Follow these steps to reproduce the multi-cloud ingestion and graph security analysis.

### Step 1: Clone Repository & Setup Configuration

```powershell
git clone <repository-url>
cd shadowhunters-cartography

# Copy environment variable templates
Copy-Item config\aws.example.env .env.aws
Copy-Item config\gcp.example.env .env.gcp
Copy-Item config\neo4j.example.env .env.neo4j
```

### Step 2: Configure Environment Credentials in Terminal

Set your active credentials in your PowerShell session (*never hardcode secrets in code*):

```powershell
# 1. Neo4j Password Environment Variable
$env:SHADOWHUNTERS_NEO4J_PASSWORD = "your-actual-neo4j-password"

# 2. AWS Credentials (Choose Option A or Option B)
# Option A: Named AWS Profile
$env:AWS_PROFILE = "default"
$env:AWS_DEFAULT_REGION = "us-east-1"

# Option B: Direct AWS Access Keys
$env:AWS_ACCESS_KEY_ID = "AKIA..."
$env:AWS_SECRET_ACCESS_KEY = "..."
$env:AWS_DEFAULT_REGION = "us-east-1"

# 3. GCP Configuration (Optional if running GCP sync)
$env:GCP_PROJECT_ID = "your-gcp-project-id"
```

### Step 3: Run Environment & Connection Check

Verify Python, Cartography, Neo4j, and cloud credential status:

```powershell
.\scripts\check-environment.ps1
```

### Step 4: Run AWS Cloud Ingestion

Execute read-only AWS infrastructure ingestion into Neo4j:

```powershell
.\scripts\run-aws.ps1
```

### Step 5: Run GCP Cloud Ingestion (Optional)

Execute read-only GCP infrastructure ingestion into Neo4j:

```powershell
.\scripts\run-gcp.ps1
```

*(Or run both clouds sequentially using `.\scripts\run-all.ps1`)*

### Step 6: Verify Ingested Neo4j Graph

Run the verification script to check node labels and total graph counts:

```powershell
.\scripts\verify-ingestion.ps1
```

### Step 7: Live Graph Schema Discovery

Inspect real node labels, relationship types, and counts present in Neo4j:

```powershell
.\scripts\inspect-schema.ps1
```

---

## 📊 Example Security & Attack Path Cypher Queries

After ingestion, connect to Neo4j Browser (`http://localhost:7474`) or run Cypher scripts to perform security analysis:

### 1. AWS IAM User & Attached Policy Discovery
```cypher
MATCH (user:AWSUser)-[:POLICY]->(policy:AWSPolicy)-[:STATEMENT]->(stmt:AWSPolicyStatement)
RETURN user.name AS user_name,
       policy.name AS policy_name,
       stmt.id AS statement_id;
```

### 2. AWS IAM Service Trust Network Visualization
```cypher
MATCH path = (role:AWSRole)-[:TRUSTS_AWS_PRINCIPAL]->(principal:AWSPrincipal)
RETURN path;
```

### 3. Bounded Multi-Hop Candidate Attack Path Analysis
```cypher
// Bounded traversal (depth <= 6) from public compute workloads to sensitive storage
MATCH p = (instance:EC2Instance)-[:MEMBER_OF_EC2_SECURITY_GROUP]->(sg:EC2SecurityGroup)-[:PART_OF_EC2_SECURITY_GROUP]->(rule:IpPermissionInbound)
WHERE rule.ip_range = '0.0.0.0/0'
WITH instance, p
MATCH path = (instance)-[*1..4]->(target:S3Bucket)
WHERE length(path) <= 6
RETURN instance.id AS entrypoint, target.id AS sensitive_target, length(path) AS depth;
```

---

## 📜 Historical Evolution

This repository evolved from an initial proof-of-concept testing Cartography against GitHub repository dependencies (e.g., `juice-shop/juice-shop`). The current architecture expands that foundation into multi-cloud (**AWS + GCP**) infrastructure mapping while retaining historical GitHub dependency artifacts for cross-domain identity and repository mapping.

---

## ❓ FAQ & Troubleshooting

- **Q: `Cannot connect to Neo4j on localhost:7687`?**  
  *Fix*: Ensure Neo4j server is started (`$env:JAVA_HOME="path/to/jdk-21"`; `neo4j.ps1 console`).
- **Q: `AWS environment validation failed`?**  
  *Fix*: Set `$env:AWS_PROFILE` or `$env:AWS_ACCESS_KEY_ID` / `$env:AWS_SECRET_ACCESS_KEY` in your active PowerShell terminal session.
- **Q: Does Cartography modify cloud resources?**  
  *Fix*: No. Cartography API calls are strictly read-only (`Describe*`, `List*`, `Get*`).

---

## 📄 License

This repository is licensed under the [Apache 2.0 License](LICENSE).
