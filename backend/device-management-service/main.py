from fastapi import FastAPI
from pydantic import BaseModel
from typing import Dict, List

app = FastAPI(title="device-management-service")

class Rule(BaseModel):
    app: str
    blocked: bool = False
    daily_limit_minutes: int = 0

_DB: Dict[str, Rule] = {}

@app.get("/")
def root():
    return {"service": "device-management-service", "status": "running"}

@app.get("/rules", response_model=List[Rule])
def list_rules():
    return list(_DB.values())

@app.post("/rules", response_model=Rule)
def create_rule(rule: Rule):
    _DB[rule.app] = rule
    return rule
