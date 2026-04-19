# 🅿️ ParkMate — Smart Parking Detector

**ParkMate** is an AI-powered parking monitoring system. It detects occupied/free spaces in real-time and displays them on a beautiful web dashboard.

---

## 🚀 Quick Start

You can set up and start the entire project with a single command:

### Linux / macOS
```bash
bash start.sh
```

### Windows (PowerShell)
```powershell
.\start.ps1
```

### What this script does:
1.  **Sets up the environment**: Installs Python and Node.js dependencies automatically.
2.  **Opens the Mapping Tool**: Allows you to mark parking spaces on the video (one-time setup).
3.  **Launches the App**: Starts the FastAPI backend and React frontend.

---

## 🎮 Basic Controls

### Mapping Tool (Optional)
If you want to re-map spaces, run `bash start.sh` and choose `y` when asked.
- **Left-click + drag**: Mark a parking space.
- **Right-click**: Remove a space.
- **S**: Save layout (**CRITICAL**).
- **Q**: Quit.

### Web Dashboard
Once the app is running:
- **URL**: [http://localhost:5173](http://localhost:5173)
- **Features**: Live video feed, occupancy stats, and dark mode.

---

## 📁 Project Structure

- `frontend/`: React + Vite web dashboard (PWA).
- `backend/`: FastAPI server + Detection engine.
- `start.sh`: Your main entry point for everything.

---

## 🛠 Troubleshooting

If you see a `ModuleNotFoundError`:
- Run `bash start.sh` again. It will verify all dependencies (including `opencv`, `cvzone`, and `torch`) are installed correctly in the isolated project environment.

---
Built with ❤️ using FastAPI, React, and OpenCV.
