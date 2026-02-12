from fastapi import FastAPI, HTTPException
from sqlalchemy import text
from shared.db.session import engine

app = FastAPI(title="Auth Service")


@app.get("/health/live")
def liveness():
    return {"status": "alive"}


@app.get("/health/ready")
def readiness():
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        return {"status": "ready"}
    except Exception as e:
        raise HTTPException(status_code=503, detail=f"database not ready: {str(e)}")
