// AWS Inventory Query: Summarize AWS accounts, EC2 instances, S3 buckets, and IAM roles
MATCH (acc:AWSAccount)
OPTIONAL MATCH (acc)-[:RESOURCE]->(instance:EC2Instance)
OPTIONAL MATCH (acc)-[:RESOURCE]->(bucket:S3Bucket)
OPTIONAL MATCH (acc)-[:RESOURCE]->(role:IAMRole)
RETURN acc.id AS account_id,
       acc.name AS account_name,
       count(DISTINCT instance) AS ec2_instances,
       count(DISTINCT bucket) AS s3_buckets,
       count(DISTINCT role) AS iam_roles;
