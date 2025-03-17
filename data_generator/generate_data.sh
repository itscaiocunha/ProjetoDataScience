#!/bin/bash

echo "Instalando dependências para geração de dados..."
sudo apt-get update
sudo apt-get install -y python3 python3-pip

echo "Instalando bibliotecas Python..."
pip3 install pandas numpy faker

echo "Gerando dados fictícios com surrealismo..."
python3 <<EOF
import pandas as pd
import numpy as np
from faker import Faker
import random
from datetime import date

fake = Faker()
data = []

# Definindo probabilidades e perfis para cada doença
doencas = {
    "HIV": {"freq": 0.14, "idade_media": 35, "idade_desvio": 7},
    "Sífilis": {"freq": 0.23, "idade_media": 30, "idade_desvio": 10},
    "Gonorreia": {"freq": 0.28, "idade_media": 28, "idade_desvio": 8},
    "HPV": {"freq": 0.28, "idade_media": 26, "idade_desvio": 6},
    # Doenças surrealistas
    "Gripe": {"freq": 0.02, "idade_media": 100, "idade_desvio": 50},
    "COVID-19": {"freq": 0.02, "idade_media": 150, "idade_desvio": 70},
    "Malária": {"freq": 0.02, "idade_media": 120, "idade_desvio": 30},
}

# Normalização das probabilidades para garantir que somem 1
total_freq = sum([doencas[d]["freq"] for d in doencas])
for d in doencas:
    doencas[d]["freq"] /= total_freq

# Função para escolher uma doença com base nas frequências
def escolher_doenca():
    nomes = list(doencas.keys())
    probs = [doencas[d]["freq"] for d in nomes]
    return np.random.choice(nomes, p=probs)

for _ in range(100000):
    doenca = escolher_doenca()

    # Geração de idade, com possibilidade de valor surreal
    if random.random() < 0.05:  # 5% de chance de idade surreal
        idade = random.choice([-5, 0, 105, 200])
    else:
        idade = int(np.random.normal(doencas[doenca]["idade_media"], doencas[doenca]["idade_desvio"]))
        idade = max(0, idade)  # Garantir idade não negativa

    # Geração de nomes e localidades surrealistas
    nome = fake.name() if random.random() > 0.02 else "!@#$%"  # 2% de nomes absurdos
    localidade = fake.city() if random.random() > 0.02 else "Cidade Inexistente"

    # Geração de data surreal
    if random.random() < 0.01:  # 1% de chance de data futura
        data_teste = fake.date_between(start_date=date(2026, 1, 1), end_date=date(2030, 12, 31)).isoformat()
    else:
        data_teste = fake.date_this_decade().isoformat()

    data.append({
        "id": fake.uuid4(),
        "nome": nome,
        "idade": idade,
        "doenca": doenca,
        "localidade": localidade,
        "nivel_educacional": fake.random_element(["Fundamental", "Médio", "Superior"]),
        "data_teste": data_teste
    })

df = pd.DataFrame(data)
df.to_csv("/vagrant/dados_ist_surrealistas.csv", index=False)
print("Dados gerados com sucesso!")
EOF
