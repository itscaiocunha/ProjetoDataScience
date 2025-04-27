import pandas as pd
import numpy as np
from faker import Faker
from datetime import date, timedelta
import random

fake = Faker('pt_BR')  # Vamos gerar em português

# Definindo as doenças
ists = {
    "HIV": {"idade_media": 35, "idade_desvio": 7},
    "Sífilis": {"idade_media": 30, "idade_desvio": 10},
    "Gonorreia": {"idade_media": 28, "idade_desvio": 8},
    "HPV": {"idade_media": 26, "idade_desvio": 6},
}

outras_doencas = {
    "Gripe": {"idade_media": 25, "idade_desvio": 15},
    "Câncer": {"idade_media": 60, "idade_desvio": 12},
    "AVC": {"idade_media": 65, "idade_desvio": 10},
    "Diabetes": {"idade_media": 50, "idade_desvio": 10},
    "Asma": {"idade_media": 20, "idade_desvio": 10},
}

# Níveis educacionais (com possíveis erros humanos)
niveis_educacionais = [
    "Fundamental", "Médio", "Superior", "fundamnetal", "medio incompleto", "superio", None, ""
]

# Funções para gerar dados com erros
def escolher_doenca():
    if random.random() < 0.6:
        # 60% de quem tem doença terá IST
        return random.choice(list(ists.keys()))
    else:
        # 40% terão outras doenças
        return random.choice(list(outras_doencas.keys()))

def gerar_idade(doenca):
    if doenca in ists:
        base = ists[doenca]
    else:
        base = outras_doencas[doenca]
    idade = int(np.random.normal(base["idade_media"], base["idade_desvio"]))
    # Introduzindo erro ocasional
    if random.random() < 0.01:
        idade = random.choice([random.randint(0, 5), random.randint(90, 100)])
    return max(0, idade)

def gerar_nome():
    nome = fake.name()
    if random.random() < 0.02:  # 2% de chance de erro
        nome = nome[:random.randint(2, len(nome)//2)]
    return nome

def gerar_data_teste():
    if random.random() < 0.02:
        # 2% chance de data inválida (futura ou antiga)
        return (date.today() + timedelta(days=random.randint(1, 1000))).isoformat()
    return fake.date_this_decade().isoformat()

def gerar_renda(nivel_educacional):
    if nivel_educacional is None or nivel_educacional.strip() == "":
        base_renda = random.randint(800, 2500)
    else:
        nivel = nivel_educacional.lower()
        if "fundam" in nivel:
            base_renda = random.randint(800, 1800)
        elif "medio" in nivel:
            base_renda = random.randint(1200, 3000)
        elif "super" in nivel:
            base_renda = random.randint(2500, 8000)
        else:
            base_renda = random.randint(1000, 2500)
    
    # Introduzindo erro ocasional
    if random.random() < 0.01:
        base_renda = random.choice([random.randint(5, 100), random.randint(30000, 100000)])
    
    # 2% chance de renda faltando
    if random.random() < 0.02:
        return None
    
    return base_renda


# Gerando os dados
total_registros = 10000
data = []

for _ in range(total_registros):
    registro = {}
    registro["id"] = fake.uuid4()
    registro["nome"] = gerar_nome()
    
    if random.random() < 0.6:
        # Pessoa doente
        doenca = escolher_doenca()
        registro["doenca"] = doenca
        registro["idade"] = gerar_idade(doenca)
    else:
        # Pessoa saudável
        registro["doenca"] = "Nenhuma"
        registro["idade"] = random.randint(0, 90)

    registro["localidade"] = fake.city() if random.random() > 0.01 else None
    registro["nivel_educacional"] = random.choice(niveis_educacionais)
    registro["renda_media"] = gerar_renda(registro["nivel_educacional"])
    registro["data_teste"] = gerar_data_teste()

    data.append(registro)

# Criando e salvando o DataFrame
df = pd.DataFrame(data)
df.to_csv("/data/dados_ist_realistas.csv", index=False, encoding='utf-8')
print("Dados gerados com realismo e erros humanos incluídos!")
