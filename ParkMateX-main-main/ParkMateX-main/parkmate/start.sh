#!/bin/bash
set -e

# ParkMate — All-in-One Startup Script
# This script handles setup, mapping, and launching everything.

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_ROOT"

echo "╔══════════════════════════════════════════╗"
echo "║          🅿️  ParkMate Launcher           ║"
echo "╚══════════════════════════════════════════╝"

# 1. Setup Backend
echo "➜ Checking backend environment..."
if [ ! -d "backend/venv" ]; then
    echo "  Creating virtual environment..."
    python3 -m venv backend/venv
fi

# Ensure pip is up to date and dependencies are installed
# We use the explicit path to avoid conflict with system/conda envs
./backend/venv/bin/python -m pip install --quiet --upgrade pip
./backend/venv/bin/python -m pip install --quiet -r backend/requirements.txt -r backend/Car-Parking-Detection/requirements.txt
echo "  ✓ Backend ready."

# 2. Setup Frontend
echo "➜ Checking frontend dependencies..."
if [ ! -d "frontend/node_modules" ]; then
    echo "  Installing npm packages (one-time setup)..."
    cd frontend && npm install --silent && cd ..
fi
echo "  ✓ Frontend ready."

# 3. Optional Mapping
POS_FILE="backend/Car-Parking-Detection/CarParkPos"
if [ ! -s "$POS_FILE" ]; then
    echo "➜ No parking layout found. You must map the spaces first."
    REMAP="y"
else
    echo "➜ Found existing parking layout."
    read -p "  Do you want to RE-MAP parking spaces? (y/N): " REMAP
    REMAP=${REMAP:-n}
fi

if [[ "$REMAP" =~ ^[Yy]$ ]]; then
    echo "  Opening Mapper... (Press 'S' to save, 'Q' to quit)"
    cd backend/Car-Parking-Detection
    ../../backend/venv/bin/python -c "from enhanced_parking_detector import EnhancedParkingDetector; d = EnhancedParkingDetector(video_path='carPark.mp4', image_path='carParkImg.jpg'); d.process_image()"
    cd ../..
    echo "  ✓ Mapping complete."
fi

# 4. Launch
echo "➜ Starting ParkMate..."
echo ""

# Start backend
cd "$PROJECT_ROOT/backend"
./venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!

# Start frontend
cd "$PROJECT_ROOT/frontend"
npm run dev &
FRONTEND_PID=$!

echo "╔══════════════════════════════════════════╗"
echo "║      🚀 ParkMate is now running!         ║"
echo "║                                          ║"
echo "║  Dashboard: http://localhost:5173        ║"
echo "║  API:       http://localhost:8000        ║"
echo "║                                          ║"
echo "║  Press Ctrl+C to stop everything.        ║"
echo "╚══════════════════════════════════════════╝"

# Cleanup on exit
trap "echo 'Shutting down...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" SIGINT SIGTERM EXIT
wait
