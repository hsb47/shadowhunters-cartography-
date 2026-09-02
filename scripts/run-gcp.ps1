# ShadowHunters Multi-Cloud Cartography - GCP Ingestion Runner
# Performs environment validation and executes read-only Cartography GCP sync.

[CmdletBinding()]
param(
    [string]$SelectedModules = "create-indexes,gcp,analysis",
    [string]$OutputFile = "$PSScriptRoot\..\output\cartography-gcp.log"
)

$ErrorActionPreference = "Stop"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " STARTING GCP CLOUD INGESTION (READ-ONLY)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# 1. Validate Environment & Credentials
& "$PSScriptRoot\check-environment.ps1" -RequireGcp
if ($LASTEXITCODE -ne 0) {
    Write-Error "GCP environment validation failed. Aborting ingestion."
    exit 1
}

# 2. Resolve Cartography Executable
$cartographyExe = $null
if ($env:CARTOGRAPHY_PATH -and (Test-Path $env:CARTOGRAPHY_PATH)) {
    $cartographyExe = $env:CARTOGRAPHY_PATH
} elseif (Test-Path "$PSScriptRoot\..\..\cartography\.venv\Scripts\cartography.exe") {
    $cartographyExe = (Resolve-Path "$PSScriptRoot\..\..\cartography\.venv\Scripts\cartography.exe").Path
} elseif (Get-Command cartography -ErrorAction SilentlyContinue) {
    $cartographyExe = (Get-Command cartography).Source
}

# 3. Resolve Neo4j Parameters
$neo4jUri = if ($env:NEO4J_URI) { $env:NEO4J_URI } else { "bolt://localhost:7687" }
$neo4jUser = if ($env:NEO4J_USER) { $env:NEO4J_USER } else { "neo4j" }
$neo4jPassEnv = if ($env:NEO4J_PASSWORD_ENV_VAR) { $env:NEO4J_PASSWORD_ENV_VAR } else { "SHADOWHUNTERS_NEO4J_PASSWORD" }

Write-Host "`nExecuting Cartography GCP Ingestion..." -ForegroundColor Yellow
Write-Host "  Cartography Executable: $cartographyExe" -ForegroundColor Gray
Write-Host "  Selected Modules:      $SelectedModules" -ForegroundColor Gray
Write-Host "  Neo4j URI:             $neo4jUri" -ForegroundColor Gray
Write-Host "  Neo4j User:            $neo4jUser" -ForegroundColor Gray
Write-Host "  Output Log:            $OutputFile" -ForegroundColor Gray

# Ensure output folder exists
$outDir = Split-Path $OutputFile -Parent
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

$args = @(
    "--neo4j-uri", "$neo4jUri",
    "--neo4j-user", "$neo4jUser",
    "--neo4j-password-env-var", "$neo4jPassEnv",
    "--selected-modules", "$SelectedModules"
)

$process = Start-Process -FilePath $cartographyExe -ArgumentList $args -NoNewWindow -PassThru -RedirectStandardOutput $OutputFile -RedirectStandardError "$OutputFile.err"
$process.WaitForExit()

if ($process.ExitCode -eq 0) {
    Write-Host "`n[SUCCESS] GCP Ingestion finished successfully." -ForegroundColor Green
    Write-Host "Log details saved to: $OutputFile" -ForegroundColor Gray
} else {
    Write-Host "`n[FAIL] GCP Ingestion process failed with exit code $($process.ExitCode)." -ForegroundColor Red
    Write-Host "Inspect log output at: $OutputFile" -ForegroundColor Red
    if (Test-Path "$OutputFile.err") {
        Get-Content "$OutputFile.err" | Select-Object -Last 20 | Write-Host -ForegroundColor Red
    }
    exit $process.ExitCode
}
