// Multi-Cloud Analysis Query: Shared Identities & Artifact Correlations
// Identifies potential cross-cloud relationship anchors (e.g. shared GitHub repositories, CI/CD pipelines, or IAM principals)

MATCH (repo:GitHubRepository)
OPTIONAL MATCH (repo)-[:RESOURCE]->(aws_res:AWSAccount)
OPTIONAL MATCH (repo)-[:RESOURCE]->(gcp_res:GCPProject)
RETURN repo.name AS repository,
       count(DISTINCT aws_res) AS aws_accounts_linked,
       count(DISTINCT gcp_res) AS gcp_projects_linked;
