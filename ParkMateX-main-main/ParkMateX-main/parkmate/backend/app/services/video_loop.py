import cv2
import numpy as np
import traceback
import threading
from datetime import datetime
from .repo_adapter import config, load_parking_positions, VIDEO_PATH

# Global state that FastAPI reads
latest_stats = {
    "total": 0,
    "occupied": 0,
    "free": 0,
    "occupancy_percent": 0.0,
    "slots": [],
    "updated_at": None,
}


class VideoLoopService:
    """
    Uses the repo's original pixel-based detection pipeline from main.py /
    enhanced_parking_detector.py: grayscale → blur → adaptive threshold → dilate,
    then count non-zero pixels per slot region to determine occupancy.
    This is the method that actually works on the carPark.mp4 video.
    """

    def __init__(self):
        self.posList = load_parking_positions()
        self.width = config.PARKING_WIDTH   # 107
        self.height = config.PARKING_HEIGHT  # 48
        self.threshold = config.OCCUPANCY_THRESHOLD  # 900
        self.cap_lock = threading.Lock()

        self.cap = None
        if not self._open_capture():
            raise IOError(f"Failed to open video: {VIDEO_PATH}")
        print(f"[VideoLoop] Loaded {len(self.posList)} parking positions from repo")
        print(f"[VideoLoop] Slot dimensions: {self.width}x{self.height}, threshold: {self.threshold}")

    def _open_capture(self):
        """Open (or reopen) the video source cleanly."""
        if self.cap is not None:
            self.cap.release()

        self.cap = cv2.VideoCapture(VIDEO_PATH)
        return self.cap.isOpened()

    def _read_looping_frame(self):
        """Read next frame and seamlessly loop at end-of-file."""
        with self.cap_lock:
            if self.cap is None or not self.cap.isOpened():
                if not self._open_capture():
                    return False, None

            success, img = self.cap.read()
            if success:
                return True, img

            # Most common case at EOF: rewind and read first frame again.
            self.cap.set(cv2.CAP_PROP_POS_FRAMES, 0)
            success, img = self.cap.read()
            if success:
                return True, img

            # Fallback for decoder/source hiccups: reopen source once and retry.
            if self.cap is not None:
                self.cap.release()
            self.cap = cv2.VideoCapture(VIDEO_PATH)
            if self.cap.isOpened():
                success, img = self.cap.read()
                if success:
                    return True, img

            return False, None

    def _process_frame(self, frame):
        """Repo's process_frame: convert to thresholded binary for pixel counting."""
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        blur = cv2.GaussianBlur(gray, (3, 3), 1)
        thresh = cv2.adaptiveThreshold(
            blur, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY_INV, 25, 16
        )
        median = cv2.medianBlur(thresh, 5)
        kernel = np.ones((3, 3), np.uint8)
        dilated = cv2.dilate(median, kernel, iterations=1)
        return dilated

    def _check_spaces(self, img_pro, img):
        """
        Repo's checkParkingSpace logic: for each slot position, crop the
        thresholded image, count non-zero pixels. Below threshold = free.
        Draws rectangles and text on img in-place.
        """
        free_count = 0
        slots_data = []

        for idx, pos in enumerate(self.posList):
            x, y = pos
            crop = img_pro[y: y + self.height, x: x + self.width]
            count = cv2.countNonZero(crop)

            if count < self.threshold:
                color = (0, 255, 0)  # Green = free
                thickness = 5
                status = "free"
                free_count += 1
            else:
                color = (0, 0, 255)  # Red = occupied
                thickness = 2
                status = "occupied"

            cv2.rectangle(img, pos, (pos[0] + self.width, pos[1] + self.height), color, thickness)
            cv2.putText(
                img, str(count), (x, y + self.height - 3),
                cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 1
            )

            slots_data.append({"id": f"Slot {idx + 1}", "status": status})

        total = len(self.posList)
        occupied = total - free_count

        # Draw summary text on frame
        cv2.putText(
            img,
            f"Free: {free_count}/{total}",
            (100, 50),
            cv2.FONT_HERSHEY_SIMPLEX,
            1.2,
            (0, 200, 0),
            3,
        )

        return total, occupied, free_count, slots_data

    def generate_frames(self):
        global latest_stats

        consecutive_read_failures = 0

        while True:
            success, img = self._read_looping_frame()
            if not success:
                consecutive_read_failures += 1
                # Keep stream alive across transient file/decoder failures.
                if consecutive_read_failures % 30 == 0:
                    print("[VideoLoop] Warning: repeated frame read failures; retrying...")
                continue

            consecutive_read_failures = 0

            try:
                processed = self._process_frame(img)
                total, occupied, free, slots_data = self._check_spaces(processed, img)

                percent = round((occupied / total * 100) if total else 0.0, 1)

                latest_stats["total"] = total
                latest_stats["occupied"] = occupied
                latest_stats["free"] = free
                latest_stats["occupancy_percent"] = percent
                latest_stats["slots"] = slots_data
                latest_stats["updated_at"] = datetime.now().isoformat()

            except Exception as e:
                print(f"[VideoLoop] Frame error: {e}")
                traceback.print_exc()

            ok, buffer = cv2.imencode('.jpg', img)
            if not ok:
                continue
            frame_bytes = buffer.tobytes()

            yield (
                b'--frame\r\n'
                b'Content-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n'
            )
