#!/bin/bash

FILE="/data/dados_ist_realistas.csv"

echo "Aguardando o arquivo $FILE aparecer..."

# Enquanto o arquivo não existir, espera 1 segundo
while [ ! -f "$FILE" ]; do
  sleep 1
done

echo "Arquivo encontrado. Rodando análise com R..."
Rscript analise.R
