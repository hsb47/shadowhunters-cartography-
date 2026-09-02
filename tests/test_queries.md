# Cypher Query Validation Test Suite

This test document outlines validation procedures for all Cypher security queries in `queries/`.

## Test Execution Checklist

- [x] `queries/inventory/node-counts.cypher`: Executes without syntax errors on Neo4j 5+.
- [x] `queries/inventory/relationship-counts.cypher`: Executes without syntax errors on Neo4j 5+.
- [x] `queries/inventory/aws-inventory.cypher`: Handles missing AWS nodes gracefully (`OPTIONAL MATCH`).
- [x] `queries/inventory/gcp-inventory.cypher`: Handles missing GCP nodes gracefully (`OPTIONAL MATCH`).
- [x] `queries/security/aws-public-resources.cypher`: Filters for Security Group `0.0.0.0/0`.
- [x] `queries/security/gcp-public-resources.cypher`: Filters for external IP strings.
- [x] `queries/security/attack-paths.cypher`: Enforces bounded path length (`length(p) <= 6`).
