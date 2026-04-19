$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location "$root\backend"

Write-Host "=== ParkMate Mapping Tool ==="
Write-Host "Left-click + drag to mark spaces, right-click to remove, 's' to save, 'q' to quit."

.\venv\Scripts\Activate.ps1
Set-Location Car-Parking-Detection

python -c @"
from enhanced_parking_detector import EnhancedParkingDetector
detector = EnhancedParkingDetector(video_path='carPark.mp4', image_path='carParkImg.jpg')
detector.process_image()
"@
