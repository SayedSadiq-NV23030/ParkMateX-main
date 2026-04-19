#!/bin/bash
set -e
cd "$(dirname "$0")/.."

echo "╔══════════════════════════════════════════╗"
echo "║       ParkMate — Full Setup & Launch     ║"
echo "║  Setup → Map Parking → Save → Run App   ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ─── STEP 1: Install backend dependencies ────────────────────────
echo "━━━ [1/5] Installing backend dependencies... ━━━"
cd backend

if [ -d "venv" ]; then
    echo "  → Virtual environment already exists, reusing it."
else
    echo "  → Creating Python virtual environment..."
    python3 -m venv venv
fi

source venv/bin/activate
pip install --quiet -r requirements.txt
pip install --quiet -r Car-Parking-Detection/requirements.txt
echo "  ✓ Backend dependencies installed."
echo ""

# ─── STEP 2: Install frontend dependencies ───────────────────────
echo "━━━ [2/5] Installing frontend dependencies... ━━━"
cd ../frontend

if [ -d "node_modules" ]; then
    echo "  → node_modules already exists, skipping npm install."
else
    npm install
fi
echo "  ✓ Frontend dependencies installed."
echo ""

# ─── STEP 3: Map parking spaces ──────────────────────────────────
cd ../backend
source venv/bin/activate

echo "━━━ [3/5] Parking Space Mapping ━━━"
echo ""

# Check if CarParkPos already exists and has content
POS_FILE="Car-Parking-Detection/CarParkPos"
if [ -s "$POS_FILE" ]; then
    LINE_COUNT=$(wc -l < "$POS_FILE" 2>/dev/null || echo "0")
    echo "  ℹ  Found existing parking layout with ~$LINE_COUNT positions."
    echo ""
    read -p "  Do you want to RE-MAP parking spaces? (y/N): " REMAP
    REMAP=${REMAP:-n}
else
    REMAP="y"
    echo "  ℹ  No existing parking layout found. Mapping is required."
fi

if [[ "$REMAP" =~ ^[Yy]$ ]]; then
    echo ""
    echo "  ┌──────────────────────────────────────────────┐"
    echo "  │  MAPPING CONTROLS:                           │"
    echo "  │    Left-click + drag → Mark parking spaces   │"
    echo "  │    Right-click       → Remove a space        │"
    echo "  │    S                 → Save layout           │"
    echo "  │    Z                 → Undo                  │"
    echo "  │    R                 → Reset all              │"
    echo "  │    D                 → Run detection test     │"
    echo "  │    Q                 → Quit mapper            │"
    echo "  │                                              │"
    echo "  │  ⚠  Press S to SAVE before pressing Q!      │"
    echo "  └──────────────────────────────────────────────┘"
    echo ""
    echo "  Opening the mapper window now..."
    echo ""

    cd Car-Parking-Detection
    ../venv/bin/python -c "
from enhanced_parking_detector import EnhancedParkingDetector
detector = EnhancedParkingDetector(video_path='carPark.mp4', image_path='carParkImg.jpg')
detector.process_image()
"
    cd ..
    echo ""
    echo "  ✓ Mapping complete. Layout saved."
else
    echo "  → Skipping mapping. Using existing layout."
fi
echo ""

# ─── STEP 4: Verify everything is ready ──────────────────────────
echo "━━━ [4/5] Verifying setup... ━━━"

if [ ! -s "$POS_FILE" ]; then
    echo "  ✗ ERROR: CarParkPos file is missing or empty!"
    echo "    Run this script again and choose to map parking spaces."
    exit 1
fi

if [ ! -f "Car-Parking-Detection/carPark.mp4" ]; then
    echo "  ✗ ERROR: carPark.mp4 video not found!"
    exit 1
fi

echo "  ✓ Parking layout:  $POS_FILE"
echo "  ✓ Video file:      Car-Parking-Detection/carPark.mp4"
echo "  ✓ Backend deps:    installed"
echo "  ✓ Frontend deps:   installed"
echo ""

# ─── STEP 5: Launch the app ──────────────────────────────────────
echo "━━━ [5/5] Starting ParkMate... ━━━"
echo ""

# Start backend
source venv/bin/activate
./venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
sleep 2

# Start frontend
cd ../frontend
npm run dev &
FRONTEND_PID=$!

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║         🅿️  ParkMate is running!         ║"
echo "║                                          ║"
echo "║  Dashboard:  http://localhost:5173        ║"
echo "║  API:        http://127.0.0.1:8000/api   ║"
echo "║  Video feed: http://127.0.0.1:8000/video_feed  ║"
echo "║                                          ║"
echo "║  Press Ctrl+C to stop everything.        ║"
echo "╚══════════════════════════════════════════╝"
echo ""

trap "echo ''; echo 'Shutting down...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; echo 'Done.'" EXIT
wait
