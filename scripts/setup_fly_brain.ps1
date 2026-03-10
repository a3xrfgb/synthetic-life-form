# Drosophila whole-brain LIF model (Eon) — clone repo and create conda env
# Run from: c:\Users\Ababiya\.cursor\eon
# Requires: Git, Miniconda/Anaconda

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$BrainDir = Join-Path $ProjectRoot "drosophila_brain_model_lif"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git not found. Install from https://git-scm.com/"
    exit 1
}
if (-not (Get-Command conda -ErrorAction SilentlyContinue)) {
    Write-Error "Conda not found. Install Miniconda: https://docs.conda.io/en/latest/miniconda.html"
    exit 1
}

if (-not (Test-Path $BrainDir)) {
    Write-Host "Cloning Eon Drosophila brain model..."
    git clone https://github.com/eonsystemspbc/drosophila_brain_model_lif.git $BrainDir
} else {
    Push-Location $BrainDir; git pull; Pop-Location
}

$envYml = Join-Path $BrainDir "environment.yml"
if (Test-Path $envYml) {
    Write-Host "Creating conda environment from environment.yml..."
    Push-Location $BrainDir
    conda env create -f environment.yml
    Pop-Location
    Write-Host "Activate: conda activate drosophila_brain_model_lif"
} else {
    $envName = "drosophila_brain_model_lif"
    conda create -n $envName python=3.10 -y
    conda run -n $envName pip install brian2 numpy pandas scipy jupyter matplotlib
    Write-Host "Activate: conda activate $envName"
}
Write-Host "Repo: $BrainDir — Connectome: FlyWire (see repo README)."
