// Security Analysis Query: AWS IAM Overly Permissive Roles & Trust Relationships
// Identifies IAM roles with AdministratorAccess or cross-account trust policies.

MATCH (role:IAMRole)-[:POLICY]->(policy:IAMPolicy)
WHERE policy.name = 'AdministratorAccess' OR policy.arn ENDS WITH 'AdministratorAccess'
OPTIONAL MATCH (instance:EC2Instance)-[:STS_ASSUME_ROLE]->(role)
RETURN role.name AS role_name,
       role.arn AS role_arn,
       policy.name AS policy_attached,
       instance.id AS attached_ec2_instance;
