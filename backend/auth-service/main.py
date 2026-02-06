from fastapi import FastAPI
from sqlalchemy import text
from backend.shared.db.session import engine

app = FastAPI(title="Auth Service")


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/db/health")
def db_health():
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        return {"database": "ok"}
    except Exception as e:
        return {"database": "error", "detail": str(e)}
