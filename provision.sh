#!/bin/bash

# Atualiza pacotes e instala dependências
sudo apt-get update
sudo apt-get install -y docker.io docker-compose

# Inicia o Docker e adiciona o usuário vagrant ao grupo docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker vagrant
