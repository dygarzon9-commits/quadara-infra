from fastapi import FastAPI
from datetime import datetime

app = FastAPI(title="monitoring-service")

@app.get("/")
def root():
    return {"service": "monitoring-service", "status": "running"}

@app.get("/healthz")
def healthz():
    return {"ok": True, "ts": datetime.utcnow().isoformat() + "Z"}
