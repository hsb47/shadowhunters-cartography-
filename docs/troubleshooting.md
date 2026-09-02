# Troubleshooting & FAQ

## Common Issues & Solutions

### 1. `Unable to locate credentials` / AWS Auth Error
- **Cause**: AWS credentials or profile environment variables are not set in the current shell session.
- **Fix**: Set `$env:AWS_PROFILE = "your-profile"` or `$env:AWS_ACCESS_KEY_ID` / `$env:AWS_SECRET_ACCESS_KEY` before running `run-aws.ps1`.

### 2. `Cannot connect to Neo4j on localhost:7687`
- **Cause**: Neo4j database server is stopped or Java version is mismatched.
- **Fix**: Ensure `$env:JAVA_HOME` points to JDK 21+ and start Neo4j (`neo4j.ps1 console`).

### 3. `Cartography release 0.140.0: DeprecationWarning`
- **Cause**: Cartography outputs Python runtime version notices.
- **Fix**: Safe to ignore; ingestion completes normally.

### 4. `Resource not accessible by personal access token` (GitHub Module)
- **Cause**: GitHub token lacks organization admin scope for `branchProtectionRules` or `outsideCollaborators`.
- **Fix**: Ingestion continues for available repositories.
