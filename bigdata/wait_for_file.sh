#!/bin/bash

FILE="/data/dados_ist_tratados.csv"

echo "Aguardando o arquivo $FILE aparecer..."

# Espera até o arquivo existir
while [ ! -f "$FILE" ]; do
  sleep 1
done

echo "Arquivo encontrado. Executando análise com Python..."
python main.py
