// GCP Inventory Query: Summarize GCP projects, Compute instances, Storage buckets, and Service Accounts
MATCH (p:GCPProject)
OPTIONAL MATCH (p)-[:RESOURCE]->(vm:GCPInstance)
OPTIONAL MATCH (p)-[:RESOURCE]->(b:GCPBucket)
OPTIONAL MATCH (p)-[:RESOURCE]->(sa:GCPServiceAccount)
RETURN p.id AS project_id,
       p.name AS project_name,
       count(DISTINCT vm) AS vm_instances,
       count(DISTINCT b) AS storage_buckets,
       count(DISTINCT sa) AS service_accounts;
