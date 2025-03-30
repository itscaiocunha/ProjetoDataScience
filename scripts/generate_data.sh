#!/bin/bash

echo "Instalando dependências..."
sudo apt-get update
sudo apt-get install -y python3 python3-pip

echo "Instalando bibliotecas Python..."
pip3 install pandas numpy faker

echo "Executando script de geração de dados..."
python3 /home/vagrant/pipeline.py
