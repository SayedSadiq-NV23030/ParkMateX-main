FROM python:3.9-slim

# Runtime libs needed by OpenCV on Debian slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install backend dependencies
COPY backend/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy backend source and assets
COPY backend/ ./backend/

ENV PORT=8080
EXPOSE 8080

# FastAPI entrypoint in this repo lives in backend/app/main.py
CMD ["uvicorn", "backend.app.main:app", "--host", "0.0.0.0", "--port", "8080"]
