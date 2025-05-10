import pandas as pd
import numpy as np
from faker import Faker
from datetime import date, timedelta
import random

fake = Faker('pt_BR')  # Gerar dados em português

# Definindo as doenças
ists = {
    "HIV": {"idade_media": 35, "idade_desvio": 7},
    "Sífilis": {"idade_media": 30, "idade_desvio": 10},
    "Gonorreia": {"idade_media": 28, "idade_desvio": 8},
    "HPV": {"idade_media": 26, "idade_desvio": 6},
    "Clamídia": {"idade_media": 24, "idade_desvio": 5},
    "Herpes Genital": {"idade_media": 29, "idade_desvio": 6},
}

outras_doencas = {
    "Gripe": {"idade_media": 25, "idade_desvio": 15},
    "Câncer": {"idade_media": 60, "idade_desvio": 12},
    "AVC": {"idade_media": 65, "idade_desvio": 10},
    "Diabetes": {"idade_media": 50, "idade_desvio": 10},
    "Asma": {"idade_media": 20, "idade_desvio": 10},
}

# Níveis educacionais com variações
niveis_educacionais = [
    "Fundamental", "Médio", "Superior", "fundamnetal", "medio incompleto", "superio", None
]

# Lista de cidades brasileiras
cidades_brasileiras = [
    # Norte
    "Manaus", "Belém", "Porto Velho", "Rio Branco", "Macapá", "Boa Vista", "Santarém", "Palmas",
    # Nordeste
    "Salvador", "Fortaleza", "Recife", "São Luís", "Maceió", "Natal", "João Pessoa", "Teresina", "Aracaju", "Feira de Santana",
    # Centro-Oeste
    "Brasília", "Goiânia", "Campo Grande", "Cuiabá", "Anápolis", "Dourados", "Rio Verde",
    # Sudeste
    "São Paulo", "Rio de Janeiro", "Belo Horizonte", "Vitória", "Campinas", "São José dos Campos", "Ribeirão Preto", "Uberlândia",
    # Sul
    "Curitiba", "Porto Alegre", "Florianópolis", "Londrina", "Maringá", "Caxias do Sul", "Pelotas", "Joinville"
]

def escolher_cidade():
    prob = random.random()
    if prob < 0.9:
        return random.choice(cidades_brasileiras)
    else:
        return None

def escolher_doenca():
    if random.random() < 0.6:
        return random.choice(list(ists.keys()))
    else:
        return random.choice(list(outras_doencas.keys()))

def gerar_idade(doenca):
    if doenca in ists:
        base = ists[doenca]
    else:
        base = outras_doencas[doenca]
    idade = int(np.random.normal(base["idade_media"], base["idade_desvio"]))
    if random.random() < 0.01:
        idade = random.choice([random.randint(0, 5), random.randint(90, 100)])
    return max(0, idade)

def gerar_genero_nome():
    prob = random.random()
    if prob < 0.6:
        nome = fake.name_male()
        genero = random.choice(["Masculino", "masculino", "M", "m"])
    elif prob < 0.8:
        nome = fake.name_female()
        genero = random.choice(["Feminino", "feminino", "F", "f"])
    elif prob < 0.2:
        nome = fake.name()
        genero = "Não informado"
    else:
        nome = fake.name()
        genero = None
    
    return nome, genero

def gerar_data_teste():
    if random.random() < 0.02:
        return (date.today() + timedelta(days=random.randint(1, 1000))).isoformat()
    return fake.date_this_decade().isoformat()

def gerar_renda(nivel_educacional):
    if nivel_educacional is None:
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
    
    if random.random() < 0.01:
        base_renda = random.choice([random.randint(5, 100), random.randint(30000, 100000)])
    
    if random.random() < 0.02:
        return None
    
    return base_renda

# Gerando os dados
total_registros = 10000
data = []

for _ in range(total_registros):
    registro = {}
    registro["id"] = fake.uuid4()
    registro["nome"], registro["genero"] = gerar_genero_nome()

    if random.random() < 0.6:
        doenca = escolher_doenca()
        registro["idade"] = gerar_idade(doenca)
        registro["doenca"] = doenca
    else:
        registro["idade"] = random.randint(0, 90)
        registro["doenca"] = "Nenhuma"

    registro["localidade"] = escolher_cidade()
    registro["nivel_educacional"] = random.choice(niveis_educacionais)
    registro["renda_media"] = gerar_renda(registro["nivel_educacional"])
    registro["data_teste"] = gerar_data_teste()

    data.append(registro)

# Criando e salvando o DataFrame
df = pd.DataFrame(data)
df.to_csv("/data/dados_ist_realistas.csv", index=False, encoding='utf-8')
print("Dados gerados com realismo e erros humanos incluídos!")
