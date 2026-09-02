# Comprehensive Multi-Criteria Research & Scorecard: Cloud & Graph Security Mapping Tools

This document presents a detailed, multi-criteria evaluation of **Cartography** and its leading open-source and commercial alternatives: **BloodHound**, **ZeusCloud**, **CloudMapper**, **Steampipe**, and **Prowler**.

---

## 1. Multi-Criteria Scorecard (1 - 10 Scale)

| Evaluation Criteria | **Cartography** | **BloodHound** | **ZeusCloud** | **CloudMapper** | **Steampipe** | **Prowler** |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **1. Multi-Cloud Support** | **9 / 10** | 6 / 10 | 8 / 10 | 2 / 10 | **10 / 10** | **9 / 10** |
| **2. Identity & IAM Depth** | 8 / 10 | **10 / 10** | 7 / 10 | 4 / 10 | 7 / 10 | 6 / 10 |
| **3. Infra Asset Coverage** | **9 / 10** | 4 / 10 | 8 / 10 | 5 / 10 | **10 / 10** | 8 / 10 |
| **4. Attack Path Analysis** | 8 / 10 | **10 / 10** | 8 / 10 | 3 / 10 | 3 / 10 | 2 / 10 |
| **5. Query Flexibility** | **10 / 10** | 8 / 10 | 6 / 10 | 2 / 10 | **9 / 10** | 3 / 10 |
| **6. Setup & Ease of Use** | 6 / 10 | 7 / 10 | **8 / 10** | 7 / 10 | **9 / 10** | **9 / 10** |
| **7. Active Maintenance** | **9 / 10** | **10 / 10** | 7 / 10 | 1 / 10 | **10 / 10** | **10 / 10** |
| **OVERALL COMPOSITE SCORE**| **8.4 / 10** | **7.9 / 10** | **7.4 / 10** | **3.4 / 10** | **8.3 / 10** | **6.7 / 10** |

---

## 2. Evaluation Criteria Definitions

1. **Multi-Cloud Support**: Native capability to query, ingest, and correlate assets across AWS, GCP, Azure, and secondary clouds/SaaS.
2. **Identity & IAM Depth**: Granularity of IAM role policies, trust relationships, Active Directory objects, Okta, and permission statements.
3. **Infrastructure Asset Coverage**: Scope of discovered resources (Compute VMs, S3/Buckets, K8s, Cloud SQL, VPCs, Security Groups, Serverless).
4. **Attack Path Analysis**: Sophistication of multi-hop relationship traversals connecting entry points to sensitive targets.
5. **Query Flexibility**: Expressiveness of the query layer (Graph Cypher vs SQL vs UI filtering).
6. **Setup & Ease of Use**: Friction of deployment, database dependencies, web UI quality, and execution overhead.
7. **Active Maintenance**: Frequency of releases, GitHub commits, community activity, and project health.

---

## 3. Deep Tool Profiles & Ratings

### 🌐 1. Cartography (Lyft) — Composite Score: 8.4 / 10

- **Multi-Cloud**: 9/10 (AWS, GCP, Azure, OCI, DigitalOcean)
- **Identity Depth**: 8/10 (AWS IAM, GCP IAM, Okta, GitHub, PagerDuty)
- **Asset Coverage**: 9/10 (Extensive compute, storage, databases, networking, Kubernetes)
- **Attack Path Analysis**: 8/10 (Requires custom Cypher bounded traversals in Neo4j)
- **Query Flexibility**: 10/10 (Full Cypher query language power in Neo4j)
- **Setup & Ease of Use**: 6/10 (Requires Python venv, Neo4j database installation, Java runtime)
- **Maintenance**: 9/10 (Actively maintained by Lyft engineering team)

**Verdict**: The most versatile **graph database engine** for security teams that want custom graph queries across multi-cloud and SaaS domains.

---

### 🩸 2. BloodHound (SpecterOps) — Composite Score: 7.9 / 10

- **Multi-Cloud**: 6/10 (Primary strength is Active Directory & Azure AD/Entra ID; AWS via extensions)
- **Identity Depth**: 10/10 (Unrivaled depth in AD object permissions, ACLs, and Kerberos/OAuth tokens)
- **Asset Coverage**: 4/10 (Minimal cloud infrastructure coverage outside identity objects)
- **Attack Path Analysis**: 10/10 (Gold standard graph algorithms for shortest-path privilege escalation)
- **Query Flexibility**: 8/10 (Cypher backend with optimized UI pathfinding presets)
- **Setup & Ease of Use**: 7/10 (BloodHound Community Edition / Enterprise containers)
- **Maintenance**: 10/10 (Backed by SpecterOps with dedicated commercial and open-source teams)

**Verdict**: The absolute best tool for **identity privilege escalation** and Active Directory / Entra ID attack path detection.

---

### ⚡ 3. ZeusCloud — Composite Score: 7.4 / 10

- **Multi-Cloud**: 8/10 (AWS, GCP, Azure)
- **Identity Depth**: 7/10 (IAM roles, service accounts, public exposure mapping)
- **Asset Coverage**: 8/10 (Core compute, storage, databases, and network objects)
- **Attack Path Analysis**: 8/10 (Pre-built attack path scoring and risk graphs in UI)
- **Query Flexibility**: 6/10 (UI-driven risk rules; limited raw Cypher custom querying)
- **Setup & Ease of Use**: 8/10 (Docker-compose single-command setup with built-in Web UI)
- **Maintenance**: 7/10 (Active open-source project)

**Verdict**: Best for teams wanting a **turnkey open-source CSPM web UI dashboard** without writing custom graph code.

---

### 🗺️ 4. CloudMapper (Duo Security) — Composite Score: 3.4 / 10

- **Multi-Cloud**: 2/10 (AWS only)
- **Identity Depth**: 4/10 (Basic AWS IAM policy parsing)
- **Asset Coverage**: 5/10 (AWS EC2, VPCs, Security Groups, S3)
- **Attack Path Analysis**: 3/10 (Static perimeter visualizer)
- **Query Flexibility**: 2/10 (Pre-canned CLI reports and static D3 web layout)
- **Setup & Ease of Use**: 7/10 (Simple Python CLI script)
- **Maintenance**: 1/10 (**Deprecated** by Duo Security; unmaintained)

**Verdict**: Legacy tool. Useful for simple AWS network diagramming, but superseded by Cartography and ZeusCloud.

---

### ⚙️ 5. Steampipe (Turbot) — Composite Score: 8.3 / 10

- **Multi-Cloud**: 10/10 (AWS, GCP, Azure, K8s, GitHub, Slack, 100+ plugins)
- **Identity Depth**: 7/10 (Exposes full IAM tables for SQL querying)
- **Asset Coverage**: 10/10 (Complete cloud API surface exposed as SQL tables)
- **Attack Path Analysis**: 3/10 (Requires complex recursive SQL `JOIN` queries)
- **Query Flexibility**: 9/10 (Standard ANSI SQL language interface)
- **Setup & Ease of Use**: 9/10 (Single binary CLI installation)
- **Maintenance**: 10/10 (Actively maintained by Turbot)

**Verdict**: Excellent for **real-time SQL compliance auditing**, but less suited for multi-hop graph pathfinding.

---

## 4. Strategic Recommendation Matrix

| Use Case Scenario | Primary Tool Recommendation | Secondary Tool |
| :--- | :--- | :--- |
| **Multi-Cloud Graph Security Graph & Cypher Queries** | **Cartography** | Steampipe |
| **Active Directory & Azure AD Identity Escalation** | **BloodHound** | Cartography |
| **Turnkey Open-Source CSPM Dashboard** | **ZeusCloud** | Prowler |
| **Real-Time SQL Cloud Auditing** | **Steampipe** | Prowler |
| **AWS Network Topology Diagramming** | **ZeusCloud** | CloudMapper (Legacy) |
