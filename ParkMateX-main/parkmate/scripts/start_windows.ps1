$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

Write-Host ""
Write-Host "========================================"
Write-Host "    ParkMate - Full Setup & Launch"
Write-Host "  Setup -> Map Parking -> Save -> Run"
Write-Host "========================================"
Write-Host ""

# --- STEP 1: Install backend dependencies ---
Write-Host "--- [1/5] Installing backend dependencies... ---"
Set-Location backend

if (-Not (Test-Path "venv")) {
    Write-Host "  -> Creating Python virtual environment..."
    python -m venv venv
} else {
    Write-Host "  -> Virtual environment already exists, reusing it."
}

& .\venv\Scripts\Activate.ps1
pip install --quiet -r requirements.txt
pip install --quiet -r Car-Parking-Detection\requirements.txt
Write-Host "  OK Backend dependencies installed."
Write-Host ""

# --- STEP 2: Install frontend dependencies ---
Write-Host "--- [2/5] Installing frontend dependencies... ---"
Set-Location ..\frontend

if (-Not (Test-Path "node_modules")) {
    npm install
} else {
    Write-Host "  -> node_modules already exists, skipping npm install."
}
Write-Host "  OK Frontend dependencies installed."
Write-Host ""

# --- STEP 3: Map parking spaces ---
Set-Location ..\backend
& .\venv\Scripts\Activate.ps1

Write-Host "--- [3/5] Parking Space Mapping ---"
Write-Host ""

$posFile = "Car-Parking-Detection\CarParkPos"
$doMap = "y"

if (Test-Path $posFile) {
    $size = (Get-Item $posFile).Length
    if ($size -gt 0) {
        Write-Host "  Found existing parking layout."
        $answer = Read-Host "  Do you want to RE-MAP parking spaces? (y/N)"
        if ($answer -ne "y" -and $answer -ne "Y") {
            $doMap = "n"
        }
    }
}

if ($doMap -eq "y") {
    Write-Host ""
    Write-Host "  MAPPING CONTROLS:"
    Write-Host "    Left-click + drag -> Mark parking spaces"
    Write-Host "    Right-click       -> Remove a space"
    Write-Host "    S                 -> Save layout"
    Write-Host "    Z                 -> Undo"
    Write-Host "    R                 -> Reset all"
    Write-Host "    D                 -> Run detection test"
    Write-Host "    Q                 -> Quit mapper"
    Write-Host ""
    Write-Host "  WARNING: Press S to SAVE before pressing Q!"
    Write-Host ""
    Write-Host "  Opening the mapper window now..."
    Write-Host ""

    Set-Location Car-Parking-Detection
    python -c @"
from enhanced_parking_detector import EnhancedParkingDetector
detector = EnhancedParkingDetector(video_path='carPark.mp4', image_path='carParkImg.jpg')
detector.process_image()
"@
    Set-Location ..
    Write-Host "  OK Mapping complete. Layout saved."
} else {
    Write-Host "  -> Skipping mapping. Using existing layout."
}
Write-Host ""

# --- STEP 4: Verify ---
Write-Host "--- [4/5] Verifying setup... ---"

if (-Not (Test-Path $posFile) -or (Get-Item $posFile).Length -eq 0) {
    Write-Host "  ERROR: CarParkPos file is missing or empty!"
    Write-Host "  Run this script again and choose to map parking spaces."
    exit 1
}

if (-Not (Test-Path "Car-Parking-Detection\carPark.mp4")) {
    Write-Host "  ERROR: carPark.mp4 video not found!"
    exit 1
}

Write-Host "  OK Parking layout:  $posFile"
Write-Host "  OK Video file:      Car-Parking-Detection\carPark.mp4"
Write-Host "  OK All dependencies installed."
Write-Host ""

# --- STEP 5: Launch ---
Write-Host "--- [5/5] Starting ParkMate... ---"
Write-Host ""

& .\venv\Scripts\Activate.ps1
$backend = Start-Process -NoNewWindow -PassThru powershell -ArgumentList "-Command", "Set-Location '$root\backend'; .\venv\Scripts\Activate.ps1; uvicorn app.main:app --host 0.0.0.0 --port 8000"
Start-Sleep 2

$frontend = Start-Process -NoNewWindow -PassThru powershell -ArgumentList "-Command", "Set-Location '$root\frontend'; npm run dev"

Write-Host ""
Write-Host "========================================"
Write-Host "    ParkMate is running!"
Write-Host ""
Write-Host "  Dashboard:  http://localhost:5173"
Write-Host "  API:        http://127.0.0.1:8000/api/stats"
Write-Host "  Video feed: http://127.0.0.1:8000/video_feed"
Write-Host ""
Write-Host "  Press Ctrl+C to stop everything."
Write-Host "========================================"
Write-Host ""

try {
    Wait-Process -Id $backend.Id
} finally {
    Stop-Process $backend -ErrorAction SilentlyContinue
    Stop-Process $frontend -ErrorAction SilentlyContinue
    Write-Host "Shutting down... Done."
}
