# Run OpenWorm Docker simulation
# Prerequisite: Run setup_openworm.ps1 once

$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$OpenWormDir = Join-Path $ProjectRoot "openworm"
$runCmd = Join-Path $OpenWormDir "run.cmd"
if (-not (Test-Path $runCmd)) {
    Write-Error "OpenWorm not found. Run .\scripts\setup_openworm.ps1 first."
    exit 1
}
Set-Location $OpenWormDir
& .\run.cmd
