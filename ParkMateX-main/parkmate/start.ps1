# ParkMate — All-in-One Startup Script (Windows)
# This script handles setup, mapping, and launching everything.

$ErrorActionPreference = "Stop"
$ProjectRoot = Get-Location

Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║          🅿️  ParkMate Launcher           ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan

# 1. Setup Backend
Write-Host "➜ Checking backend environment..." -ForegroundColor Yellow
if (-not (Test-Path "backend\venv")) {
    Write-Host "  Creating virtual environment..."
    python -m venv backend\venv
}

# Ensure pip is up to date and dependencies are installed
Write-Host "  Installing/Updating dependencies..."
& ".\backend\venv\Scripts\python.exe" -m pip install --quiet --upgrade pip
& ".\backend\venv\Scripts\python.exe" -m pip install --quiet -r backend\requirements.txt -r backend\Car-Parking-Detection\requirements.txt
Write-Host "  ✓ Backend ready." -ForegroundColor Green

# 2. Setup Frontend
Write-Host "➜ Checking frontend dependencies..." -ForegroundColor Yellow
if (-not (Test-Path "frontend\node_modules")) {
    Write-Host "  Installing npm packages (one-time setup)..."
    Set-Location frontend
    npm install --silent
    Set-Location $ProjectRoot
}
Write-Host "  ✓ Frontend ready." -ForegroundColor Green

# 3. Optional Mapping
$PosFile = "backend\Car-Parking-Detection\CarParkPos"
$Remap = "n"

if (-not (Test-Path $PosFile) -or (Get-Item $PosFile).Length -eq 0) {
    Write-Host "➜ No parking layout found. You must map the spaces first." -ForegroundColor Cyan
    $Remap = "y"
} else {
    Write-Host "➜ Found existing parking layout." -ForegroundColor Cyan
    $Input = Read-Host "  Do you want to RE-MAP parking spaces? (y/N)"
    if ($Input -eq "y" -or $Input -eq "Y") { $Remap = "y" }
}

if ($Remap -eq "y") {
    Write-Host "  Opening Mapper... (Press 'S' to save, 'Q' to quit)" -ForegroundColor Gray
    Set-Location "backend\Car-Parking-Detection"
    & "..\venv\Scripts\python.exe" -c "from enhanced_parking_detector import EnhancedParkingDetector; d = EnhancedParkingDetector(video_path='carPark.mp4', image_path='carParkImg.jpg'); d.process_image()"
    Set-Location $ProjectRoot
    Write-Host "  ✓ Mapping complete." -ForegroundColor Green
}

# 4. Launch
Write-Host "➜ Starting ParkMate..." -ForegroundColor Yellow
Write-Host ""

# Start backend
Set-Location "backend"
$BackendProcess = Start-Process -FilePath ".\venv\Scripts\uvicorn.exe" -ArgumentList "app.main:app", "--host", "0.0.0.0", "--port", "8000" -PassThru -NoNewWindow
Set-Location $ProjectRoot

# Start frontend
Set-Location "frontend"
$FrontendProcess = Start-Process -FilePath "npm.cmd" -ArgumentList "run", "dev" -PassThru -NoNewWindow
Set-Location $ProjectRoot

Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║      🚀 ParkMate is now running!         ║" -ForegroundColor Cyan
Write-Host "║                                          ║" -ForegroundColor Cyan
Write-Host "║  Dashboard: http://localhost:5173        ║" -ForegroundColor Cyan
Write-Host "║  API:       http://localhost:8000        ║" -ForegroundColor Cyan
Write-Host "║                                          ║" -ForegroundColor Cyan
Write-Host "║  Close this window to stop everything.   ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan

# Keep script running to maintain background processes
try {
    Wait-Process -Id $BackendProcess.Id, $FrontendProcess.Id
} finally {
    Stop-Process -Id $BackendProcess.Id -ErrorAction SilentlyContinue
    Stop-Process -Id $FrontendProcess.Id -ErrorAction SilentlyContinue
}
