FROM python:3.11-slim

WORKDIR /app

# Copiar requirements
COPY backend/auth-service/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código del servicio
COPY backend/auth-service/main.py .

# Copiar carpeta shared
COPY backend/shared ./shared

ENV PYTHONPATH=/app

EXPOSE 80

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
