import pandas as pd
import numpy as np
from faker import Faker
from datetime import date

fake = Faker()

# Definindo probabilidades e perfis para cada doença
doencas = {
    "HIV": {"freq": 0.14, "idade_media": 35, "idade_desvio": 7},
    "Sífilis": {"freq": 0.23, "idade_media": 30, "idade_desvio": 10},
    "Gonorreia": {"freq": 0.28, "idade_media": 28, "idade_desvio": 8},
    "HPV": {"freq": 0.28, "idade_media": 26, "idade_desvio": 6},
}

# Normalização das probabilidades
total_freq = sum(d["freq"] for d in doencas.values())
for d in doencas:
    doencas[d]["freq"] /= total_freq

# Função para escolher uma doença com base nas frequências
def escolher_doenca():
    nomes = list(doencas.keys())
    probs = [doencas[d]["freq"] for d in nomes]
    return np.random.choice(nomes, p=probs)

# Gerando os dados de forma otimizada
data = [
    {
        "id": fake.uuid4(),
        "nome": fake.name(),
        "idade": int(np.random.normal(doencas[(doenca := escolher_doenca())]["idade_media"], 
                                      doencas[doenca]["idade_desvio"])),
        "doenca": doenca,
        "localidade": fake.city(),
        "nivel_educacional": fake.random_element(["Fundamental", "Médio", "Superior"]),
        "data_teste": fake.date_this_decade().isoformat()
    }
    for _ in range(100000)
]

# Criando e salvando o DataFrame
df = pd.DataFrame(data)
df.to_csv("/vagrant/data/dados_ist.csv", index=False)
print("Dados gerados com sucesso!")
