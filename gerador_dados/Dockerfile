FROM python:3.11-slim

WORKDIR /app
COPY gerador_dados.py .
RUN pip install pandas numpy faker
RUN mkdir -p /data

CMD ["python", "gerador_dados.py"]

