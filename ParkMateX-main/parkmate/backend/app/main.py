from fastapi import FastAPI
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware

from .services.video_loop import VideoLoopService, latest_stats

app = FastAPI(title="ParkMate API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

video_service = None


@app.on_event("startup")
async def startup_event():
    global video_service
    video_service = VideoLoopService()


@app.get('/api/health')
def health():
    return {"status": "ok"}


@app.get('/api/stats')
def get_stats():
    return latest_stats


@app.get('/api/slots')
def get_slots():
    return latest_stats.get("slots", [])


@app.get('/video_feed')
def video_feed():
    if not video_service:
        return {"error": "Video service not initialized"}
    return StreamingResponse(
        video_service.generate_frames(),
        media_type='multipart/x-mixed-replace; boundary=frame'
    )
