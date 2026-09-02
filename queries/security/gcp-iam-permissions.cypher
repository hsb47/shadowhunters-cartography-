// Security Analysis Query: GCP Service Account Roles & Permissions
// Identifies GCP Service Accounts bound to privileged roles (e.g. Owner, Editor, Secret Manager Admin).

MATCH (sa:GCPServiceAccount)-[:RESOURCE]->(role:GCPRole)
WHERE role.name CONTAINS 'roles/owner' OR role.name CONTAINS 'roles/editor' OR role.name CONTAINS 'admin'
OPTIONAL MATCH (vm:GCPInstance)-[:USES]->(sa)
RETURN sa.email AS service_account,
       role.name AS granted_role,
       vm.name AS attached_vm_instance;
