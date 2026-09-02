# Neo4j Database & Graph Management

## Connection Details

- **URI**: `bolt://localhost:7687`
- **HTTP Browser Interface**: `http://localhost:7474`
- **Default Database**: `neo4j`

## Neo4j Configuration (`neo4j.conf`)

Ensure the local Neo4j server has Java JDK 21+ configured via `JAVA_HOME`.

```powershell
$env:JAVA_HOME = "path/to/jdk-21"
.\bin\neo4j.ps1 console
```

## Data Cleanup & Reset Guidelines

Cartography applies an `--update-tag` timestamp to nodes during sync. Stale nodes from prior runs are updated or cleaned up automatically by Cartography.

If you wish to perform a full manual reset of the local graph database in Cypher:

```cypher
// WARNING: Clears all nodes and relationships in the active database
MATCH (n) DETACH DELETE n;
```
