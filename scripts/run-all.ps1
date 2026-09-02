# ShadowHunters Multi-Cloud Cartography - Sequential All-Cloud Ingestion Runner
# Performs environment verification, followed by AWS and GCP ingestion sequentially.

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " STARTING SHADOWHUNTERS MULTI-CLOUD INGESTION (AWS + GCP)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# 1. Environment Verification
Write-Host "`n[STEP 1/3] Validating Environment & Credentials..." -ForegroundColor Yellow
& "$PSScriptRoot\check-environment.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Environment check failed. Aborting multi-cloud ingestion."
    exit 1
}

# 2. Execute AWS Ingestion
Write-Host "`n[STEP 2/3] Executing AWS Ingestion..." -ForegroundColor Yellow
& "$PSScriptRoot\run-aws.ps1"
$awsCode = $LASTEXITCODE

# 3. Execute GCP Ingestion
Write-Host "`n[STEP 3/3] Executing GCP Ingestion..." -ForegroundColor Yellow
& "$PSScriptRoot\run-gcp.ps1"
$gcpCode = $LASTEXITCODE

Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host " MULTI-CLOUD INGESTION SUMMARY" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

Write-Host " AWS Ingestion Status: " -NoNewline
if ($awsCode -eq 0) { Write-Host "SUCCESS" -ForegroundColor Green } else { Write-Host "FAILED ($awsCode)" -ForegroundColor Red }

Write-Host " GCP Ingestion Status: " -NoNewline
if ($gcpCode -eq 0) { Write-Host "SUCCESS" -ForegroundColor Green } else { Write-Host "FAILED ($gcpCode)" -ForegroundColor Red }

if ($awsCode -eq 0 -and $gcpCode -eq 0) {
    Write-Host "`n[PASSED] Multi-cloud ingestion completed successfully." -ForegroundColor Green
} else {
    Write-Host "`n[WARNING] One or more cloud ingestion steps failed." -ForegroundColor Red
    exit 1
}
