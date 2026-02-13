FROM python:3.11-slim

WORKDIR /app

COPY backend/device-management-service/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/device-management-service .

COPY backend/shared ./shared

ENV PYTHONPATH=/app

EXPOSE 80

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
