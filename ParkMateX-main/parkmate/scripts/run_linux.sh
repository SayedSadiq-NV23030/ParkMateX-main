#!/bin/bash
set -e
cd "$(dirname "$0")/.."

echo "=== ParkMate Run ==="

# Start backend
echo "[1/2] Starting backend on http://127.0.0.1:8000 ..."
cd backend
source venv/bin/activate
./venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
cd ..

# Start frontend
echo "[2/2] Starting frontend on http://localhost:5173 ..."
cd frontend
npm run dev &
FRONTEND_PID=$!
cd ..

echo ""
echo "ParkMate is running!"
echo "  Dashboard: http://localhost:5173"
echo "  API:       http://127.0.0.1:8000/api/stats"
echo "  Video:     http://127.0.0.1:8000/video_feed"
echo ""
echo "Press Ctrl+C to stop."

trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null" EXIT
wait
