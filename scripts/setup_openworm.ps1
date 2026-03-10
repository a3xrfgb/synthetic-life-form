# OpenWorm — Clone and run the full C. elegans simulation (Docker)
# Run from: c:\Users\Ababiya\.cursor\eon
# Requires: Git, Docker Desktop (running)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$OpenWormDir = Join-Path $ProjectRoot "openworm"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git not found. Install from https://git-scm.com/"
    exit 1
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Warning "Docker not found or not in PATH. Install Docker Desktop and ensure it's running."
    Write-Host "  https://www.docker.com/products/docker-desktop/"
    exit 1
}

try { docker info 2>&1 | Out-Null } catch {
    Write-Warning "Docker daemon not reachable. Start Docker Desktop and try again."
    exit 1
}

if (-not (Test-Path $OpenWormDir)) {
    Write-Host "Cloning OpenWorm..."
    git clone https://github.com/openworm/OpenWorm.git $OpenWormDir
} else {
    Write-Host "OpenWorm directory already exists: $OpenWormDir"
    Push-Location $OpenWormDir; git pull; Pop-Location
}

Write-Host ""
Write-Host "OpenWorm is at: $OpenWormDir"
Write-Host "Next: cd $OpenWormDir ; .\build.cmd ; .\run.cmd"
Write-Host "Or: .\scripts\run_openworm.ps1"
