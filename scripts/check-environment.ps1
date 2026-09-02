# ShadowHunters Multi-Cloud Cartography - Environment Verification Script
# Validates Python, Cartography, Neo4j connectivity, AWS credentials, and GCP auth.

[CmdletBinding()]
param(
    [switch]$RequireAws = $false,
    [switch]$RequireGcp = $false
)

$ErrorActionPreference = "Continue"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " SHADOWHUNTERS ENVIRONMENT VERIFICATION" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$allPass = $true

# 1. Resolve Python Executable
Write-Host "`n[1/5] Checking Python Environment..." -NoNewline
$pythonExe = $null
if ($env:PYTHON_PATH -and (Test-Path $env:PYTHON_PATH)) {
    $pythonExe = $env:PYTHON_PATH
} elseif (Test-Path "$PSScriptRoot\..\..\cartography\.venv\Scripts\python.exe") {
    $pythonExe = (Resolve-Path "$PSScriptRoot\..\..\cartography\.venv\Scripts\python.exe").Path
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonExe = (Get-Command python).Source
}

if ($pythonExe) {
    $pyVer = & $pythonExe --version 2>&1
    Write-Host " [PASS]" -ForegroundColor Green
    Write-Host "      Path: $pythonExe" -ForegroundColor Gray
    Write-Host "      Version: $pyVer" -ForegroundColor Gray
} else {
    Write-Host " [FAIL]" -ForegroundColor Red
    Write-Host "      Error: Python executable could not be resolved." -ForegroundColor Red
    $allPass = $false
}

# 2. Resolve Cartography Executable
Write-Host "`n[2/5] Checking Cartography Executable..." -NoNewline
$cartographyExe = $null
if ($env:CARTOGRAPHY_PATH -and (Test-Path $env:CARTOGRAPHY_PATH)) {
    $cartographyExe = $env:CARTOGRAPHY_PATH
} elseif (Test-Path "$PSScriptRoot\..\..\cartography\.venv\Scripts\cartography.exe") {
    $cartographyExe = (Resolve-Path "$PSScriptRoot\..\..\cartography\.venv\Scripts\cartography.exe").Path
} elseif (Get-Command cartography -ErrorAction SilentlyContinue) {
    $cartographyExe = (Get-Command cartography).Source
}

if ($cartographyExe) {
    $cartVer = & $cartographyExe --version 2>&1 | Select-String "cartography release"
    Write-Host " [PASS]" -ForegroundColor Green
    Write-Host "      Path: $cartographyExe" -ForegroundColor Gray
    if ($cartVer) { Write-Host "      Version: $($cartVer.Line)" -ForegroundColor Gray }
} else {
    Write-Host " [FAIL]" -ForegroundColor Red
    Write-Host "      Error: Cartography executable not found." -ForegroundColor Red
    $allPass = $false
}

# 3. Check Neo4j Connectivity
Write-Host "`n[3/5] Checking Neo4j Database Server..." -NoNewline
$neo4jUri = if ($env:NEO4J_URI) { $env:NEO4J_URI } else { "bolt://localhost:7687" }
$hostName = "localhost"
$port = 7687
if ($neo4jUri -match "bolt://([^:]+):(\d+)") {
    $hostName = $matches[1]
    $port = [int]$matches[2]
}

$connTest = Test-NetConnection -ComputerName $hostName -Port $port -WarningAction SilentlyContinue
if ($connTest.TcpTestSucceeded) {
    Write-Host " [PASS]" -ForegroundColor Green
    Write-Host "      Endpoint: $neo4jUri" -ForegroundColor Gray
} else {
    Write-Host " [FAIL]" -ForegroundColor Red
    Write-Host "      Error: Cannot connect to Neo4j on $hostName`:$port" -ForegroundColor Red
    Write-Host "      Remediation: Ensure Neo4j server is started." -ForegroundColor Yellow
    $allPass = $false
}

# 4. Check AWS Authentication State
Write-Host "`n[4/5] Checking AWS Authentication Configuration..." -NoNewline
$awsAuthFound = $false
$awsDetails = @()

if ($env:AWS_PROFILE) {
    $awsAuthFound = $true
    $awsDetails += "AWS_PROFILE='$($env:AWS_PROFILE)'"
}
if ($env:AWS_ACCESS_KEY_ID) {
    $awsAuthFound = $true
    $awsDetails += "AWS_ACCESS_KEY_ID is configured"
}
if (Test-Path "$env:USERPROFILE\.aws\credentials") {
    $awsAuthFound = $true
    $awsDetails += "AWS Credentials File exists (~/.aws/credentials)"
}

if ($awsAuthFound) {
    Write-Host " [PASS]" -ForegroundColor Green
    foreach ($detail in $awsDetails) {
        Write-Host "      $detail" -ForegroundColor Gray
    }
} else {
    if ($RequireAws) {
        Write-Host " [FAIL]" -ForegroundColor Red
        Write-Host "      Error: No AWS credentials or profiles detected." -ForegroundColor Red
        $allPass = $false
    } else {
        Write-Host " [WARN]" -ForegroundColor Yellow
        Write-Host "      Notice: No active AWS profile/credentials set in current session." -ForegroundColor Yellow
    }
}

# 5. Check GCP Authentication State
Write-Host "`n[5/5] Checking GCP Authentication Configuration..." -NoNewline
$gcpAuthFound = $false
$gcpDetails = @()

if ($env:GCP_PROJECT_ID) {
    $gcpAuthFound = $true
    $gcpDetails += "GCP_PROJECT_ID='$($env:GCP_PROJECT_ID)'"
}
if ($env:GOOGLE_APPLICATION_CREDENTIALS) {
    $gcpAuthFound = $true
    $gcpDetails += "GOOGLE_APPLICATION_CREDENTIALS is configured"
}
if (Test-Path "$env:USERPROFILE\AppData\Roaming\gcloud\credentials.db") {
    $gcpAuthFound = $true
    $gcpDetails += "gcloud ADC credentials DB exists"
}

if ($gcpAuthFound) {
    Write-Host " [PASS]" -ForegroundColor Green
    foreach ($detail in $gcpDetails) {
        Write-Host "      $detail" -ForegroundColor Gray
    }
} else {
    if ($RequireGcp) {
        Write-Host " [FAIL]" -ForegroundColor Red
        Write-Host "      Error: No GCP credentials or project ID detected." -ForegroundColor Red
        $allPass = $false
    } else {
        Write-Host " [WARN]" -ForegroundColor Yellow
        Write-Host "      Notice: No active GCP project/ADC set in current session." -ForegroundColor Yellow
    }
}

Write-Host "`n============================================================" -ForegroundColor Cyan
if ($allPass) {
    Write-Host " ENVIRONMENT CHECK STATUS: READY" -ForegroundColor Green
} else {
    Write-Host " ENVIRONMENT CHECK STATUS: FAILED / ACTION REQUIRED" -ForegroundColor Red
}
Write-Host "============================================================" -ForegroundColor Cyan

if (-not $allPass) { exit 1 }
