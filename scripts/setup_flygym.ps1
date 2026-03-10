# FlyGym / NeuroMechFly v2 — clone and install
# Run from: c:\Users\Ababiya\.cursor\eon
# Requires: Git, Conda. GPU (e.g. RTX 3090) recommended.

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$FlyGymDir = Join-Path $ProjectRoot "flygym"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Write-Error "Git not found."; exit 1 }
if (-not (Get-Command conda -ErrorAction SilentlyContinue)) { Write-Error "Conda not found."; exit 1 }

if (-not (Test-Path $FlyGymDir)) {
    Write-Host "Cloning FlyGym (NeuroMechFly v2)..."
    git clone https://github.com/NeLy-EPFL/flygym.git $FlyGymDir
} else { Push-Location $FlyGymDir; git pull; Pop-Location }

$envName = "flygym"
$envYml = Join-Path $FlyGymDir "environment.yml"
$pyProject = Join-Path $FlyGymDir "pyproject.toml"

if (Test-Path $envYml) {
    Push-Location $FlyGymDir; conda env create -f environment.yml; Pop-Location
} else {
    conda create -n $envName python=3.10 -y
    conda run -n $envName pip install "gymnasium>=0.29" "mujoco>=2.3"
    conda run -n $envName pip install -e $FlyGymDir
}
Write-Host "FlyGym at: $FlyGymDir — Activate: conda activate $envName — Docs: https://neuromechfly.org/"
