// Candidate Attack Path Analysis Query (Bounded Traversal)
// Identifies candidate relationship chains from exposed workloads to sensitive assets.
// Note: Graph paths represent analytical relationship chains, not confirmed vulnerabilities.

// AWS Candidate Path: Public Compute -> IAM Role -> S3 Storage / Secrets
MATCH p = (instance:EC2Instance)-[:MEMBER_OF_EC2_SECURITY_GROUP]->(sg:EC2SecurityGroup)-[:PART_OF_EC2_SECURITY_GROUP]->(rule:IpPermissionInbound)
WHERE rule.ip_range = '0.0.0.0/0'
WITH instance, p
MATCH path = (instance)-[*1..4]->(target:S3Bucket)
WHERE length(path) <= 6
RETURN instance.id AS exposed_entrypoint,
       target.id AS sensitive_target,
       [n IN nodes(path) | labels(n)[0]] AS node_chain,
       length(path) AS path_length;

// GCP Candidate Path: Public VM -> Service Account -> Sensitive Storage
MATCH p2 = (vm:GCPInstance)-[*1..4]->(bucket:GCPBucket)
WHERE vm.public_ip IS NOT NULL AND vm.public_ip <> '' AND length(p2) <= 6
RETURN vm.name AS exposed_entrypoint,
       bucket.id AS sensitive_target,
       [n IN nodes(p2) | labels(n)[0]] AS node_chain,
       length(p2) AS path_length;
