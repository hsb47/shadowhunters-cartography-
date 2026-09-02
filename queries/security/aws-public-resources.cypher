// Security Exposure Query: AWS Public Resources
// Identifies EC2 instances exposed to 0.0.0.0/0 via Security Groups and public S3 buckets.

// 1. EC2 Instances exposed to public internet
MATCH (instance:EC2Instance)-[:MEMBER_OF_EC2_SECURITY_GROUP]->(sg:EC2SecurityGroup)-[:PART_OF_EC2_SECURITY_GROUP]->(rule:IpPermissionInbound)
WHERE rule.ip_range = '0.0.0.0/0' OR rule.fromport = 0 OR rule.fromport = 22 OR rule.fromport = 80 OR rule.fromport = 443
RETURN instance.id AS instance_id,
       instance.publicdnsname AS public_dns,
       instance.publicipaddress AS public_ip,
       sg.groupid AS security_group,
       rule.fromport AS open_port,
       rule.protocol AS protocol
ORDER BY instance.id;

// 2. S3 Buckets with public access permissions
MATCH (b:S3Bucket)
WHERE b.anonymous_access = true OR b.is_public = true
RETURN b.id AS bucket_name,
       b.region AS region,
       b.anonymous_access AS anonymous_access;
