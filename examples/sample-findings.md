# Sample Findings & Analysis Reports (Sanitized)

## Finding 1: Internet-Exposed Compute Instance

- **Category**: Exposure
- **Resource**: `i-0123456789abcdef0` (AWS EC2 Instance)
- **Security Group**: `sg-0abc1234def56789`
- **Rule**: Inbound `0.0.0.0/0` on port `22` (SSH)
- **Attached IAM Role**: `arn:aws:iam::123456789012:role/AppServerRole`
- **Impact**: Anyone on the internet can attempt network connections to port 22. If SSH credentials/keys are compromised, attached IAM role permissions become accessible.

## Finding 2: Publicly Accessible Cloud Storage Bucket

- **Category**: Exposure
- **Resource**: `example-sanitized-data-bucket` (GCP Bucket)
- **Location**: `US-MULTI-REGION`
- **Permission**: `allUsers` / `Storage Object Viewer`
- **Impact**: All objects in the storage bucket are readable by anonymous internet users.
