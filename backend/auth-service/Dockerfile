FROM python:3.11-slim

WORKDIR /app

# Copiar requirements desde backend/auth-service
COPY auth-service/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código del servicio
COPY auth-service/main.py .

# Copiar carpeta shared desde backend/shared
COPY shared ./shared

ENV PYTHONPATH=/app

EXPOSE 80

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
