import pandas as pd

# Caminho para o CSV compartilhado
path = "/data/dados_ist_tratados.csv"

# Carregando os dados
try:
    df = pd.read_csv(path)
    print("Dados carregados com sucesso!")
except FileNotFoundError:
    print(f"Arquivo não encontrado em {path}")
    exit()

# Exemplo simples de análise
print(df.info())
print(df.describe())

# Contagem por doença
print(df['doenca'].value_counts())

# Exporta como parquet, por exemplo
df.to_parquet("/data/dados_bigdata.parquet", index=False)