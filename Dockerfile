# Imagem base
FROM python:3.11-slim

# Diretório de trabalho dentro do container
WORKDIR /app

# Copiar o script Python para dentro do container
COPY gerador_dados.py .

# Instalar dependências
RUN pip install pandas numpy faker

# Criar a pasta de saída dos dados
RUN mkdir -p /data/raw

# Comando para rodar o script
CMD ["python", "gerador_dados.py"]
