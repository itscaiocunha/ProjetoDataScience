#!/bin/bash

# Verifica se o Python está instalado
if ! command -v python3 &> /dev/null
then
    echo "Python3 não encontrado. Instalando..."
    sudo apt-get install -y python3 python3-pip
fi

# Executa o pipeline
echo "Gerando dados..."
python3 "$(dirname "$0")/pipeline.py"

echo "Processo concluído!"