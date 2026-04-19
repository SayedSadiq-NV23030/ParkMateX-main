import sys
import os
import pickle

# Add the base repository to sys.path so we can import config directly
REPO_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "Car-Parking-Detection")
if REPO_PATH not in sys.path:
    sys.path.insert(0, REPO_PATH)

# Import repo's config module (contains PARKING_WIDTH, PARKING_HEIGHT, OCCUPANCY_THRESHOLD, etc.)
import config


def load_parking_positions():
    """
    Load parking slot positions from the repo's CarParkPos file.
    The repo stores positions as a list of (x, y) tuples, either pickled or as plain text CSV.
    """
    pos_file = os.path.join(REPO_PATH, config.POSITION_FILE)
    if not os.path.exists(pos_file):
        print(f"[repo_adapter] Warning: Position file {pos_file} not found.")
        return []

    with open(pos_file, "rb") as f:
        try:
            return pickle.load(f)
        except Exception:
            # Fallback: file is plain text with x,y per line
            f.seek(0)
            lines = f.read().decode('utf-8', errors='ignore').splitlines()
            pos = []
            for line in lines:
                line = line.strip()
                if line and ',' in line:
                    try:
                        parts = [p.strip() for p in line.split(',')]
                        if len(parts) < 2:
                            continue
                        x, y = int(parts[0]), int(parts[1])
                        pos.append((x, y))
                    except ValueError:
                        pass
            return pos


# Path to the repo's bundled sample video
VIDEO_PATH = os.path.join(REPO_PATH, "carPark.mp4")

__all__ = ["config", "load_parking_positions", "VIDEO_PATH"]
