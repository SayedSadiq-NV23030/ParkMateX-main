Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

Write-Host "=== ParkMate Setup (Windows) ==="

# Backend
Write-Host "[1/3] Setting up backend..."
Set-Location backend
python -m venv venv 2>$null
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
pip install -r Car-Parking-Detection\requirements.txt
deactivate
Set-Location ..

# Frontend
Write-Host "[2/3] Setting up frontend..."
Set-Location frontend
npm install
Set-Location ..

Write-Host "[3/3] Setup complete!"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Map parking spaces: .\scripts\map_windows.ps1"
Write-Host "  2. Run the app:        .\scripts\run_windows.ps1"
