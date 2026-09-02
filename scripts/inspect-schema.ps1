# ShadowHunters Multi-Cloud Cartography - Schema Discovery & Inspection Script
# Queries live Neo4j database to record active node labels, relationship types, and property keys.

[CmdletBinding()]
param(
    [string]$OutputFile = "$PSScriptRoot\..\output\schema-summary.txt"
)

$ErrorActionPreference = "Stop"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " INSPECTING NEO4J GRAPH SCHEMA & INGESTED DATA" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# 1. Resolve Python Executable
$pythonExe = $null
if ($env:PYTHON_PATH -and (Test-Path $env:PYTHON_PATH)) {
    $pythonExe = $env:PYTHON_PATH
} elseif (Test-Path "$PSScriptRoot\..\..\cartography\.venv\Scripts\python.exe") {
    $pythonExe = (Resolve-Path "$PSScriptRoot\..\..\cartography\.venv\Scripts\python.exe").Path
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonExe = (Get-Command python).Source
}

if (-not $pythonExe) {
    Write-Error "Python executable not found. Cannot run Neo4j schema inspection."
    exit 1
}

# 2. Run Python Schema Inspector Inline Script
$pyScript = @"
import os
import sys
from neo4j import GraphDatabase

uri = os.environ.get("NEO4J_URI", "bolt://localhost:7687")
user = os.environ.get("NEO4J_USER", "neo4j")
pass_var = os.environ.get("NEO4J_PASSWORD_ENV_VAR", "SHADOWHUNTERS_NEO4J_PASSWORD")
password = os.environ.get(pass_var) or os.environ.get("SHADOWHUNTERS_NEO4J_PASSWORD") or os.environ.get("NEO4J_PASSWORD") or "neo4j"

print(f"Connecting to Neo4j at {uri}...")

try:
    driver = GraphDatabase.driver(uri, auth=(user, password))
    with driver.session() as session:
        # 1. Total node count
        total_nodes = session.run("MATCH (n) RETURN count(n) as count").single()["count"]
        print(f"\n--- TOTAL NODES IN GRAPH: {total_nodes} ---")

        # 2. Node labels and counts
        labels_res = session.run("MATCH (n) UNWIND labels(n) AS label RETURN label, count(*) AS count ORDER BY count DESC")
        labels = [r for r in labels_res]
        print("\n--- NODE LABELS ---")
        for r in labels:
            print(f"  {r['label']}: {r['count']}")

        # 3. Total relationship count
        total_rels = session.run("MATCH ()-[r]->() RETURN count(r) as count").single()["count"]
        print(f"\n--- TOTAL RELATIONSHIPS IN GRAPH: {total_rels} ---")

        # 4. Relationship types and counts
        rels_res = session.run("MATCH ()-[r]->() RETURN type(r) AS rel_type, count(r) AS count ORDER BY count DESC")
        rels = [r for r in rels_res]
        print("\n--- RELATIONSHIP TYPES ---")
        for r in rels:
            print(f"  {r['rel_type']}: {r['count']}")

    driver.close()
    print("\nSchema inspection completed successfully.")
except Exception as e:
    print(f"\n[ERROR] Neo4j Schema Inspection Failed: {e}", file=sys.stderr)
    sys.exit(1)
"@

$pyTempPath = "$PSScriptRoot\..\output\_temp_inspect.py"
$pyScript | Out-File -FilePath $pyTempPath -Encoding utf8

$outDir = Split-Path $OutputFile -Parent
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

Write-Host "Running schema discovery query against Neo4j..." -ForegroundColor Yellow
$result = & $pythonExe $pyTempPath 2>&1
Remove-Item -Path $pyTempPath -ErrorAction SilentlyContinue

$result | Out-File -FilePath $OutputFile -Encoding utf8
$result | Write-Host

Write-Host "`nSchema inspection saved to: $OutputFile" -ForegroundColor Green
