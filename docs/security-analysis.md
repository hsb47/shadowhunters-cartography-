# Security Analysis & Attack Path Methodology

## Five-Level Security Taxonomy

1. **Inventory**: Resource discovery and mapping.
2. **Exposure**: Network reachability (e.g. `0.0.0.0/0` security group rules, public IPs, public buckets).
3. **Risky Permissions**: Overly permissive IAM policies or cross-account trusts.
4. **Candidate Attack Paths**: Multi-hop graph relationship paths connecting external exposure to internal assets.
5. **Confirmed Vulnerabilities**: Evidence derived from vulnerability scanners (CVEs, exploit proof).

## Attack Path Traversal Principles

Graph queries use bounded depth traversals (`length(path) <= 6`) to prevent query performance degradation while exposing multi-step relationship chains:

```cypher
MATCH p = (entrypoint:EC2Instance)-[*1..4]->(target:S3Bucket)
WHERE length(p) <= 6
RETURN entrypoint.id, target.id, [n IN nodes(p) | labels(n)[0]] AS chain;
```
