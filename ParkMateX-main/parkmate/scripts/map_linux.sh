#!/bin/bash
set -e
cd "$(dirname "$0")/../backend"

echo "=== ParkMate Mapping Tool ==="
echo "This runs the repo's interactive parking space selector."
echo "Left-click + drag to mark spaces, right-click to remove, 's' to save, 'q' to quit."
echo ""

source venv/bin/activate

# Run the repo's parking space selector on the video's first frame image
cd Car-Parking-Detection
../venv/bin/python -c "
from enhanced_parking_detector import EnhancedParkingDetector
detector = EnhancedParkingDetector(video_path='carPark.mp4', image_path='carParkImg.jpg')
detector.process_image()
"
