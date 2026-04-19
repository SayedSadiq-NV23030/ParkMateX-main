$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host "=== ParkMate Run ==="

# Backend
Write-Host "[1/2] Starting backend..."
$backend = Start-Process -NoNewWindow -PassThru -FilePath "cmd" -ArgumentList "/c cd /d $root\backend && .\venv\Scripts\activate && uvicorn app.main:app --host 0.0.0.0 --port 8000"

# Frontend
Write-Host "[2/2] Starting frontend..."
$frontend = Start-Process -NoNewWindow -PassThru -FilePath "cmd" -ArgumentList "/c cd /d $root\frontend && npm run dev"

Write-Host ""
Write-Host "ParkMate is running!"
Write-Host "  Dashboard: http://localhost:5173"
Write-Host "  API:       http://127.0.0.1:8000/api/stats"
Write-Host "  Video:     http://127.0.0.1:8000/video_feed"
Write-Host ""
Write-Host "Press Ctrl+C to stop."

try { Wait-Process -Id $backend.Id } finally { Stop-Process $backend, $frontend -ErrorAction SilentlyContinue }
