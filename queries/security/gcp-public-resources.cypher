// Security Exposure Query: GCP Public Compute & Storage Resources
// Identifies GCP Compute instances with public IP addresses and public Storage buckets.

// 1. GCP Compute VMs with external IP addresses
MATCH (vm:GCPInstance)
WHERE vm.public_ip IS NOT NULL AND vm.public_ip <> ''
RETURN vm.id AS instance_id,
       vm.name AS instance_name,
       vm.public_ip AS external_ip,
       vm.zone AS zone;

// 2. Public GCP Storage Buckets
MATCH (b:GCPBucket)
WHERE b.is_public = true OR b.all_users_authenticated = true
RETURN b.id AS bucket_id,
       b.location AS location,
       b.is_public AS public_access;
