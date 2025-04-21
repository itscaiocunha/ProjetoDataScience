FROM python:3.9-slim
WORKDIR /app
COPY ./scripts/data_generation/ ./
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python3", "pipeline.py"]