#!/bin/bash
set -e
cd "$(dirname "$0")/.."

echo "=== ParkMate Setup (Linux) ==="

# Backend
echo "[1/3] Setting up backend..."
cd backend
python3 -m venv venv 2>/dev/null || true
source venv/bin/activate
pip install -r requirements.txt
pip install -r Car-Parking-Detection/requirements.txt
deactivate
cd ..

# Frontend
echo "[2/3] Setting up frontend..."
cd frontend
npm install
cd ..

echo "[3/3] Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Map parking spaces: bash scripts/map_linux.sh"
echo "  2. Run the app:        bash scripts/run_linux.sh"
