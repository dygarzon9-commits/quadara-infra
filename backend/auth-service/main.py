from fastapi import FastAPI, HTTPException

app = FastAPI(title="auth-service")

@app.get("/")
def root():
    return {"service": "auth-service", "status": "running"}

@app.post("/login")
def login(username: str, password: str):
    if not username or not password:
        raise HTTPException(status_code=400, detail="username and password required")
    return {"access_token": "demo-token", "token_type": "bearer"}
