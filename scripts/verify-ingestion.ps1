# ShadowHunters Multi-Cloud Cartography - Ingestion Verification Script
# Verifies presence of AWS and GCP infrastructure nodes and relationships in Neo4j.

[CmdletBinding()]
param(
    [string]$OutputFile = "$PSScriptRoot\..\output\verification-report.txt"
)

$ErrorActionPreference = "Stop"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " VERIFYING NEO4J CLOUD GRAPH INGESTION" -ForegroundColor Cyan
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
    Write-Error "Python executable not found. Cannot verify Neo4j graph."
    exit 1
}

# 2. Run Python Graph Verification Script
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
        # Total Nodes & Relationships
        total_nodes = session.run("MATCH (n) RETURN count(n) as count").single()["count"]
        total_rels = session.run("MATCH ()-[r]->() RETURN count(r) as count").single()["count"]

        # AWS Node Filter
        aws_nodes = session.run(
            "MATCH (n) WHERE any(l IN labels(n) WHERE l STARTS WITH 'AWS' OR l IN ['EC2Instance','S3Bucket','EC2SecurityGroup','IAMUser','IAMRole']) RETURN count(n) as count"
        ).single()["count"]

        # GCP Node Filter
        gcp_nodes = session.run(
            "MATCH (n) WHERE any(l IN labels(n) WHERE l STARTS WITH 'GCP' OR l IN ['GCPProject','GCPInstance','GCPBucket','GCPServiceAccount']) RETURN count(n) as count"
        ).single()["count"]

        # GitHub Node Filter
        github_nodes = session.run(
            "MATCH (n) WHERE any(l IN labels(n) WHERE l STARTS WITH 'GitHub') RETURN count(n) as count"
        ).single()["count"]

        print("============================================================")
        print(" INGESTION VERIFICATION SUMMARY")
        print("============================================================")
        print(f" Total Nodes in Database:         {total_nodes}")
        print(f" Total Relationships in Database: {total_rels}")
        print(f" AWS Cloud Nodes:                 {aws_nodes}")
        print(f" GCP Cloud Nodes:                 {gcp_nodes}")
        print(f" GitHub Artifact Nodes:           {github_nodes}")
        print("------------------------------------------------------------")

        status_passed = False
        if total_nodes > 0:
            status_passed = True
            print(" [PASS] Neo4j graph populated successfully.")
        else:
            print(" [FAIL] Neo4j graph is empty. Ingestion has not loaded data.")

    driver.close()
    if not status_passed:
        sys.exit(1)
except Exception as e:
    print(f"\n[ERROR] Verification Failed: {e}", file=sys.stderr)
    sys.exit(1)
"@

$pyTempPath = "$PSScriptRoot\..\output\_temp_verify.py"
$pyScript | Out-File -FilePath $pyTempPath -Encoding utf8

$outDir = Split-Path $OutputFile -Parent
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

Write-Host "Executing graph verification query..." -ForegroundColor Yellow
$result = & $pythonExe $pyTempPath 2>&1
$exitCode = $LASTEXITCODE
Remove-Item -Path $pyTempPath -ErrorAction SilentlyContinue

$result | Out-File -FilePath $OutputFile -Encoding utf8
$result | Write-Host

Write-Host "`nVerification report saved to: $OutputFile" -ForegroundColor Green
if ($exitCode -ne 0) { exit $exitCode }
