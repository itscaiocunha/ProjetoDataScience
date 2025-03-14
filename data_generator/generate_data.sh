#!/bin/bash

echo "Instalando dependências para geração de dados..."
sudo apt-get update
sudo apt-get install -y python3 python3-pip

echo "Instalando bibliotecas Python..."
pip3 install pandas numpy faker

echo "Gerando dados fictícios..."
python3 <<EOF
import pandas as pd
import numpy as np
from faker import Faker

fake = Faker()
data = []

for _ in range(1000):
    data.append({
        "id": fake.uuid4(),
        "nome": fake.name(),
        "idade": np.random.randint(0, 200),
        "doenca": fake.word(ext_word_list=["HIV", "Sífilis", "Gonorreia", "HPV", "Cancer", "Gripe", "Leptospirose", "Pneumonia"]),
        "localidade": fake.city(),
        "data_teste": fake.date_this_decade().isoformat()
    })

df = pd.DataFrame(data)
df.to_csv("/vagrant/dados_ist.csv", index=False)
df.to_json("/vagrant/dados_ist.json", orient="records", lines=True)
print("Dados gerados com sucesso!")
EOF
