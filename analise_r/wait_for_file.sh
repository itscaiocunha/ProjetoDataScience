#!/bin/bash

# Define o caminho do arquivo CSV
CSV_FILE="/data/dados_ist_realistas.csv"

# Define os detalhes de conexão do PostgreSQL
# O host deve ser o nome do serviço PostgreSQL no seu docker-compose.yml
DB_HOST="postgres"
DB_PORT="5432" # Porta padrão do PostgreSQL

echo "Aguardando o arquivo CSV ($CSV_FILE) e o PostgreSQL em $DB_HOST:$DB_PORT ficarem prontos..."

# Loop enquanto o arquivo CSV não existir OU o PostgreSQL não estiver pronto
while [ ! -f "$CSV_FILE" ] || ! pg_isready -h "$DB_HOST" -p "$DB_PORT" -q; do
  # Mensagens de progresso (opcional, para feedback)
  if [ ! -f "$CSV_FILE" ]; then
    echo "  - CSV não encontrado, aguardando..."
  fi
  if ! pg_isready -h "$DB_HOST" -p "$DB_PORT" -q; then
    echo "  - PostgreSQL não está pronto, aguardando..."
  fi
  sleep 2 # Espera 2 segundos antes de verificar novamente
done

echo "Arquivo CSV encontrado e PostgreSQL pronto. Rodando análise com R..."
Rscript analise.R