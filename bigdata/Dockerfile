FROM python:3.11-slim

WORKDIR /app

# Instala dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o script Python e o script de espera
COPY main.py .
COPY wait_for_file.sh .

# Dá permissão de execução
RUN chmod +x wait_for_file.sh

# Comando padrão
CMD ["./wait_for_file.sh"]
